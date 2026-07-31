#Requires -Version 5.1
param(
    [switch]$Apply
)
$ErrorActionPreference = 'Stop'

# ---- Exit codes ----
# 0  nothing to create (already conforms) OR apply completed successfully
# 1  dry-run: plan generated, confirmation needed before -Apply
# 2  not an AIS-OS project
# 10 preflight failure (this skill's own bundled templates/manifest are missing/corrupt)
# 30 apply failure, rollback completed
# 31 apply failure, rollback INCOMPLETE (manual cleanup needed)

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
        Write-Host "RESULT: FAILED, rolled back."
        exit 30
    }
    else {
        Write-Host "Rollback INCOMPLETE. Manual cleanup required, see ROLLBACK FAILED/SKIPPED lines above."
        Write-Host "RESULT: FAILED, rollback incomplete."
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
        $preflightOk = $false
    }
}

if (-not $preflightOk) {
    Write-Host ""
    Write-Host "Preflight failed. No target changes made."
    exit 10
}
Write-Host "Preflight passed: all $($Manifest.files.Count) bundled templates verified."
Write-Host ""

$CreatedDirs = New-Object System.Collections.Generic.List[string]
$CreatedFiles = New-Object System.Collections.Generic.List[string]

try {
    # ================= STEP 2: NON-AIOS PROJECT DETECTION =================
    Write-Host "== Checking whether this is an AIS-OS project =="

    $foundDistinctive = $false
    foreach ($d in $Manifest.distinctive_identifier_files) {
        $full = Join-RelPath $TargetRoot $d
        if (Test-Path -LiteralPath $full) { $foundDistinctive = $true; break }
    }

    if (-not $foundDistinctive) {
        Write-Host ""
        Write-Host "This doesn't look like an AIS-OS project - no AIS-OS identifying files were found."
        Write-Host "Did you mean to run aios-structure-build here instead?"
        exit 2
    }
    Write-Host "AIS-OS project detected. Proceeding."
    Write-Host ""

    # ================= STEP 3: SCAN FOR MISSING ITEMS =================
    Write-Host "== Scanning for missing baseline items =="

    $blockedDirs = New-Object System.Collections.Generic.List[string]
    $missingDirs = New-Object System.Collections.Generic.List[string]

    foreach ($d in $Manifest.directories) {
        $full = Join-RelPath $TargetRoot $d
        if (Test-Path -LiteralPath $full -PathType Container) {
            if (Test-IsReparsePoint $full) { $blockedDirs.Add($d) }
            # else: exists normally, nothing to do
        }
        else {
            $missingDirs.Add($d)
        }
    }

    $missingFiles = New-Object System.Collections.Generic.List[object]
    $blockedFiles = New-Object System.Collections.Generic.List[string]

    foreach ($f in $Manifest.files) {
        $full = Join-RelPath $TargetRoot $f.path
        if (Test-Path -LiteralPath $full) { continue }  # exists -> additive-only, never touched

        $parentDir = Split-Path -Parent $f.path
        $parentDir = if ($parentDir) { $parentDir -replace '\\', '/' } else { $null }
        if ($parentDir -and ($blockedDirs -contains $parentDir)) {
            $blockedFiles.Add($f.path)
        }
        else {
            $missingFiles.Add($f)
        }
    }

    $foundAntiPatterns = New-Object System.Collections.Generic.List[string]
    foreach ($ap in $Manifest.anti_pattern_paths) {
        $full = Join-RelPath $TargetRoot $ap
        if (Test-Path -LiteralPath $full) { $foundAntiPatterns.Add($ap) }
    }

    $totalToCreate = $missingDirs.Count + $missingFiles.Count

    if ($totalToCreate -eq 0) {
        Write-Host ""
        Write-Host "Nothing to create - project already has the full baseline."
        if ($blockedDirs.Count -gt 0 -or $blockedFiles.Count -gt 0) {
            Write-Host ""
            Write-Host "Blocked (reparse point in the way, skipped):"
            foreach ($b in $blockedDirs) { Write-Host "- $b" }
            foreach ($b in $blockedFiles) { Write-Host "- $b" }
        }
        if ($foundAntiPatterns.Count -gt 0) {
            Write-Host ""
            Write-Host "Found but not modified (out of scope for this skill):"
            foreach ($a in $foundAntiPatterns) { Write-Host "- $a" }
            Write-Host "Run /aios-structure-validate for details."
        }
        Write-Host ""
        Write-Host "RESULT: SUCCESS (nothing to do)"
        exit 0
    }

    if (-not $Apply) {
        # ================= DRY RUN REPORT =================
        Write-Host ""
        Write-Host "== Dry run: AIS-OS Structure Organize =="
        Write-Host ""
        Write-Host "Will create:"
        foreach ($d in $missingDirs) { Write-Host "- directory: $d" }
        foreach ($mf in $missingFiles) { Write-Host "- file: $($mf.path) (tier: $($mf.tier))" }

        if ($blockedDirs.Count -gt 0 -or $blockedFiles.Count -gt 0) {
            Write-Host ""
            Write-Host "Blocked (reparse point in the way, skipped):"
            foreach ($b in $blockedDirs) { Write-Host "- $b" }
            foreach ($b in $blockedFiles) { Write-Host "- $b" }
        }

        if ($foundAntiPatterns.Count -gt 0) {
            Write-Host ""
            Write-Host "Found but not modified (out of scope for this skill):"
            foreach ($a in $foundAntiPatterns) { Write-Host "- $a" }
            Write-Host "Run /aios-structure-validate for details."
        }

        Write-Host ""
        Write-Host "Total items to create: $totalToCreate"
        Write-Host "PLAN_READY: confirmation needed before applying"
        exit 1
    }

    # ================= STEP 4: APPLY =================
    Write-Host ""
    Write-Host "== Applying: AIS-OS Structure Organize =="

    foreach ($d in $missingDirs) {
        $full = Join-RelPath $TargetRoot $d
        New-Item -ItemType Directory -Path $full -Force | Out-Null
        $CreatedDirs.Add($d)
    }
    foreach ($mf in $missingFiles) {
        $srcPath = Join-RelPath $TemplatesDir $mf.path
        $dstPath = Join-RelPath $TargetRoot $mf.path
        [System.IO.File]::Copy($srcPath, $dstPath, $false)
        $CreatedFiles.Add($mf.path)
    }

    # ================= STEP 5: POST-WRITE VERIFICATION =================
    $verifyOk = $true
    foreach ($d in $CreatedDirs) {
        $full = Join-RelPath $TargetRoot $d
        if (-not (Test-Path -LiteralPath $full -PathType Container)) {
            Write-Host "FAIL: missing after write: $d"
            $verifyOk = $false
        }
    }
    foreach ($fp in $CreatedFiles) {
        $full = Join-RelPath $TargetRoot $fp
        if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
            Write-Host "FAIL: missing after write: $fp"
            $verifyOk = $false
        }
    }

    if (-not $verifyOk) {
        Exit-WithRollback -TargetRoot $TargetRoot -CreatedFiles $CreatedFiles -CreatedDirs $CreatedDirs -Reason "post-write verification failed"
    }

    Write-Host ""
    Write-Host "Created:"
    foreach ($d in ($CreatedDirs | Sort-Object)) { Write-Host "- directory: $d" }
    foreach ($fp in ($CreatedFiles | Sort-Object)) { Write-Host "- file: $fp" }

    if ($blockedDirs.Count -gt 0 -or $blockedFiles.Count -gt 0) {
        Write-Host ""
        Write-Host "Blocked (reparse point in the way, skipped):"
        foreach ($b in $blockedDirs) { Write-Host "- $b" }
        foreach ($b in $blockedFiles) { Write-Host "- $b" }
    }

    if ($foundAntiPatterns.Count -gt 0) {
        Write-Host ""
        Write-Host "Found but not modified (out of scope for this skill):"
        foreach ($a in $foundAntiPatterns) { Write-Host "- $a" }
        Write-Host "Run /aios-structure-validate for details."
    }

    Write-Host ""
    Write-Host "RESULT: SUCCESS"
    exit 0
}
catch {
    Exit-WithRollback -TargetRoot $TargetRoot -CreatedFiles $CreatedFiles -CreatedDirs $CreatedDirs -Reason "unexpected error: $($_.Exception.Message)"
}
