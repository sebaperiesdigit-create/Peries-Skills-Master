#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

# ---- Exit codes ----
# 0  success, full verification passed
# 10 preflight failure (skill package problem)
# 20 target collision / not empty
# 30 write or verification failure, rollback completed
# 31 write or verification failure, rollback INCOMPLETE (manual cleanup needed)

function Get-NormalizedHash {
    param([string]$Path)
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    $norm = $text -replace "`r`n", "`n" -replace "`r", "`n"
    $normBytes = [System.Text.Encoding]::UTF8.GetBytes($norm)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { -join ($sha.ComputeHash($normBytes) | ForEach-Object { $_.ToString('x2') }) }
    finally { $sha.Dispose() }
}

function Test-IsReparsePoint {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $item = Get-Item -LiteralPath $Path -Force
    return [bool]($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)
}

function Join-RelPath {
    param([string]$Root, [string]$RelPath)
    Join-Path $Root ($RelPath -replace '/', '\')
}

function Invoke-Rollback {
    param([string]$TargetRoot, [System.Collections.Generic.List[string]]$CreatedFiles, [System.Collections.Generic.List[string]]$CreatedDirs)
    $ok = $true
    foreach ($fp in $CreatedFiles) {
        $full = Join-RelPath $TargetRoot $fp
        try { if (Test-Path -LiteralPath $full) { Remove-Item -LiteralPath $full -Force } }
        catch { $ok = $false; Write-Host "  ROLLBACK FAILED to remove file: $fp ($($_.Exception.Message))" }
    }
    $dirsDeepestFirst = $CreatedDirs | Sort-Object { ($_ -split '/').Count } -Descending
    foreach ($dp in $dirsDeepestFirst) {
        $full = Join-RelPath $TargetRoot $dp
        try {
            if (Test-Path -LiteralPath $full) {
                $remaining = @(Get-ChildItem -LiteralPath $full -Force -Name)
                if ($remaining.Count -eq 0) { Remove-Item -LiteralPath $full -Force }
                else { $ok = $false; Write-Host "  ROLLBACK SKIPPED non-empty created dir: $dp" }
            }
        }
        catch { $ok = $false; Write-Host "  ROLLBACK FAILED to remove dir: $dp ($($_.Exception.Message))" }
    }
    return $ok
}

function Exit-WithRollback {
    param([string]$TargetRoot, [System.Collections.Generic.List[string]]$CreatedFiles, [System.Collections.Generic.List[string]]$CreatedDirs, [string]$Reason)
    Write-Host "FAIL: $Reason"
    Write-Host "Rolling back paths created during this attempt..."
    $rollbackOk = Invoke-Rollback -TargetRoot $TargetRoot -CreatedFiles $CreatedFiles -CreatedDirs $CreatedDirs
    if ($rollbackOk) {
        Write-Host "Rollback complete. Target restored to its pre-invocation state."
        exit 30
    }
    else {
        Write-Host "Rollback INCOMPLETE. Manual cleanup required, see ROLLBACK FAILED/SKIPPED lines above."
        exit 31
    }
}

# ---- Resolve skill-relative paths (never derived from cwd) ----
$ScriptPath = $MyInvocation.MyCommand.Path
$ScriptsDir = Split-Path -Parent $ScriptPath
$SkillRoot = Split-Path -Parent $ScriptsDir
$ManifestPath = Join-Path $SkillRoot 'manifest.json'
$TemplatesDir = Join-Path $SkillRoot 'templates'
$TargetRoot = (Get-Location).Path

Write-Host "Skill root:  $SkillRoot"
Write-Host "Target root: $TargetRoot"
Write-Host ""

# ================= STEP 1: PREFLIGHT =================
Write-Host "== Preflight: validating skill package =="

if (-not (Test-Path -LiteralPath $ManifestPath)) {
    Write-Host "FAIL: manifest.json not found at $ManifestPath"
    exit 10
}
try {
    $Manifest = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
} catch {
    Write-Host "FAIL: manifest.json is not valid JSON: $($_.Exception.Message)"
    exit 10
}

$preflightOk = $true
foreach ($f in $Manifest.files) {
    $tPath = Join-RelPath $TemplatesDir $f.path
    if (-not (Test-Path -LiteralPath $tPath -PathType Leaf)) {
        Write-Host "FAIL: template missing: $($f.path)"
        $preflightOk = $false
        continue
    }
    if (Test-IsReparsePoint $tPath) {
        Write-Host "FAIL: template is a reparse point (refusing to trust): $($f.path)"
        $preflightOk = $false
        continue
    }
    try {
        $hash = Get-NormalizedHash $tPath
    } catch {
        Write-Host "FAIL: template unreadable: $($f.path) ($($_.Exception.Message))"
        $preflightOk = $false
        continue
    }
    if ($hash -ne $f.sha256_normalized) {
        Write-Host "FAIL: template hash mismatch: $($f.path)"
        Write-Host "      expected: $($f.sha256_normalized)"
        Write-Host "      actual:   $hash"
        $preflightOk = $false
    }
}

if (-not $preflightOk) {
    Write-Host ""
    Write-Host "Preflight failed. No changes made to target."
    exit 10
}
Write-Host "Preflight passed: all $($Manifest.files.Count) templates present and verified."
Write-Host ""

# ---- Everything from here on can touch the target, so any unexpected ----
# ---- exception must still result in a clean rollback + defined exit code. ----
$CreatedDirs = New-Object System.Collections.Generic.List[string]
$CreatedFiles = New-Object System.Collections.Generic.List[string]

try {
    # ================= STEP 2: EMPTINESS CHECK =================
    Write-Host "== Checking target directory =="

    $Allowlist = @($Manifest.allowlisted_installation_dirs)
    $Preserved = New-Object System.Collections.Generic.List[string]
    $abortReason = $null

    $topEntries = @(Get-ChildItem -LiteralPath $TargetRoot -Force -Name)

    if ($topEntries.Count -eq 0) {
        # fully empty target
    }
    else {
        foreach ($e in $topEntries) {
            if ($e -ne '.claude') {
                $abortReason = "unexpected item in target: $e"
                break
            }
        }

        if (-not $abortReason) {
            $claudePath = Join-Path $TargetRoot '.claude'
            $claudeItem = Get-Item -LiteralPath $claudePath -Force
            if (-not $claudeItem.PSIsContainer -or (Test-IsReparsePoint $claudePath)) {
                $abortReason = ".claude exists but is not a plain directory"
            }
        }

        if (-not $abortReason) {
            $claudePath = Join-Path $TargetRoot '.claude'
            $claudeEntries = @(Get-ChildItem -LiteralPath $claudePath -Force -Name)
            foreach ($ce in $claudeEntries) {
                if ($ce -ne 'skills') {
                    $abortReason = "unexpected item under .claude: $ce"
                    break
                }
            }
        }

        if (-not $abortReason) {
            $skillsPath = Join-Path $TargetRoot '.claude\skills'
            if (Test-Path -LiteralPath $skillsPath) {
                $skillsItem = Get-Item -LiteralPath $skillsPath -Force
                if (-not $skillsItem.PSIsContainer -or (Test-IsReparsePoint $skillsPath)) {
                    $abortReason = ".claude/skills exists but is not a plain directory"
                }
                else {
                    $skillEntries = @(Get-ChildItem -LiteralPath $skillsPath -Force -Name)
                    foreach ($se in $skillEntries) {
                        $relSkillPath = ".claude/skills/$se"
                        if ($Allowlist -notcontains $relSkillPath) {
                            $abortReason = "unexpected skill folder under .claude/skills: $se"
                            break
                        }
                        $seFullPath = Join-Path $skillsPath $se
                        if (Test-IsReparsePoint $seFullPath) {
                            $abortReason = "allowlisted skill folder '$se' is a reparse point; treating as collision"
                            break
                        }
                        $Preserved.Add($relSkillPath)
                    }
                }
            }
        }
    }

    if ($abortReason) {
        Write-Host "FAIL: target is not empty ($abortReason)."
        Write-Host "No changes made. Use aios-structure-validate or aios-structure-organize for a non-empty project."
        exit 20
    }

    Write-Host "Target check passed."
    if ($Preserved.Count -gt 0) {
        Write-Host "Preserved existing AIOS skill installation(s), will not be touched:"
        foreach ($p in $Preserved) { Write-Host "  - $p" }
    }
    else {
        Write-Host "Target is fully empty."
    }
    Write-Host ""

    # ================= STEP 3: COLLISION VALIDATION =================
    Write-Host "== Validating destination paths for collisions =="

    $collision = $false
    foreach ($d in $Manifest.directories) {
        $full = Join-RelPath $TargetRoot $d
        if (Test-Path -LiteralPath $full) {
            if ($d -ne '.claude' -and $d -ne '.claude/skills') {
                Write-Host "FAIL: unexpected pre-existing directory: $d"
                $collision = $true
            }
        }
    }
    foreach ($f in $Manifest.files) {
        $full = Join-RelPath $TargetRoot $f.path
        if (Test-Path -LiteralPath $full) {
            Write-Host "FAIL: unexpected pre-existing file: $($f.path)"
            $collision = $true
        }
    }
    if ($collision) {
        Write-Host ""
        Write-Host "Collision check failed. No changes made."
        exit 20
    }
    Write-Host "No collisions. Safe to write."
    Write-Host ""

    # ================= STEP 4: WRITE =================
    Write-Host "== Writing baseline =="

    foreach ($d in $Manifest.directories) {
        $full = Join-RelPath $TargetRoot $d
        if (Test-Path -LiteralPath $full) {
            # only .claude / .claude/skills may legitimately pre-exist (tolerated containers)
            continue
        }
        New-Item -ItemType Directory -Path $full -Force | Out-Null
        $CreatedDirs.Add($d)
    }
    foreach ($f in $Manifest.files) {
        $srcPath = Join-RelPath $TemplatesDir $f.path
        $dstPath = Join-RelPath $TargetRoot $f.path
        [System.IO.File]::Copy($srcPath, $dstPath, $false)
        $CreatedFiles.Add($f.path)
    }

    $dirNoun = if ($CreatedDirs.Count -eq 1) { 'directory' } else { 'directories' }
    Write-Host "Wrote $($CreatedDirs.Count) $dirNoun and $($CreatedFiles.Count) files."
    Write-Host ""

    # ================= STEP 5: POST-BUILD VERIFICATION =================
    Write-Host "== Post-build verification =="

    $verifyOk = $true
    foreach ($f in $Manifest.files) {
        $full = Join-RelPath $TargetRoot $f.path
        if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
            Write-Host "FAIL: missing after write: $($f.path)"
            $verifyOk = $false
            continue
        }
        if (Test-IsReparsePoint $full) {
            Write-Host "FAIL: written path is unexpectedly a reparse point: $($f.path)"
            $verifyOk = $false
            continue
        }
        $h = Get-NormalizedHash $full
        if ($h -ne $f.sha256_normalized) {
            Write-Host "FAIL: hash mismatch after write: $($f.path)"
            $verifyOk = $false
        }
    }
    foreach ($d in $Manifest.directories) {
        $full = Join-RelPath $TargetRoot $d
        if (-not (Test-Path -LiteralPath $full -PathType Container)) {
            Write-Host "FAIL: missing directory after write: $d"
            $verifyOk = $false
        }
    }

    # scan for unexpected paths (skip recursing into preserved allowlisted folders)
    function Test-UnexpectedPaths {
        param([string]$Dir, [string]$RelPrefix, [string[]]$ExpectedFiles, [string[]]$ExpectedDirs, [string[]]$PreservedRel)
        $unexpected = New-Object System.Collections.Generic.List[string]
        $entries = @(Get-ChildItem -LiteralPath $Dir -Force)
        foreach ($entry in $entries) {
            $rel = if ($RelPrefix) { "$RelPrefix/$($entry.Name)" } else { $entry.Name }
            if ($PreservedRel -contains $rel) { continue }  # never descend into preserved folders
            if (Test-IsReparsePoint $entry.FullName) {
                $unexpected.Add("$rel (reparse point)")
                continue
            }
            if ($entry.PSIsContainer) {
                if ($ExpectedDirs -contains $rel) {
                    $sub = Test-UnexpectedPaths -Dir $entry.FullName -RelPrefix $rel -ExpectedFiles $ExpectedFiles -ExpectedDirs $ExpectedDirs -PreservedRel $PreservedRel
                    foreach ($u in $sub) { $unexpected.Add($u) }
                }
                else {
                    $unexpected.Add("$rel/")
                }
            }
            else {
                if ($ExpectedFiles -notcontains $rel) { $unexpected.Add($rel) }
            }
        }
        return $unexpected
    }

    $expectedDirs = @($Manifest.directories)
    $expectedFiles = @($Manifest.files | ForEach-Object { $_.path })
    $unexpectedPaths = Test-UnexpectedPaths -Dir $TargetRoot -RelPrefix '' -ExpectedFiles $expectedFiles -ExpectedDirs $expectedDirs -PreservedRel @($Preserved)
    if ($unexpectedPaths.Count -gt 0) {
        foreach ($u in $unexpectedPaths) { Write-Host "FAIL: unexpected path created: $u" }
        $verifyOk = $false
    }

    if (-not $verifyOk) {
        Exit-WithRollback -TargetRoot $TargetRoot -CreatedFiles $CreatedFiles -CreatedDirs $CreatedDirs -Reason "post-build verification failed"
    }

    Write-Host "Verification passed: complete baseline tree confirmed, no unexpected paths."
    Write-Host ""

    # ================= STEP 6: REPORT =================
    Write-Host "CREATED_FILES_START"
    foreach ($fp in ($CreatedFiles | Sort-Object)) { Write-Host $fp }
    Write-Host "CREATED_FILES_END"
    Write-Host "PRESERVED_START"
    foreach ($p in $Preserved) { Write-Host $p }
    Write-Host "PRESERVED_END"
    Write-Host "RESULT: SUCCESS"
    exit 0
}
catch {
    Exit-WithRollback -TargetRoot $TargetRoot -CreatedFiles $CreatedFiles -CreatedDirs $CreatedDirs -Reason "unexpected error: $($_.Exception.Message)"
}
