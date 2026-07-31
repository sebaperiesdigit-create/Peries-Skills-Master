#Requires -Version 5.1
param(
    [switch]$SaveReport
)
$ErrorActionPreference = 'Stop'

# ---- Exit codes ----
# 0  scan completed, project fully conforms (zero issues)
# 1  scan completed, issues found (see report)
# 2  not an AIS-OS project (no distinctive identifier files found)
# 10 preflight failure (this skill's own bundled templates/manifest are missing/corrupt)
# 20 unexpected error during scan

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
    Write-Host "Preflight failed. Scan not performed."
    exit 10
}
Write-Host "Preflight passed: all $($Manifest.files.Count) bundled templates verified."
Write-Host ""

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
    Write-Host "AIS-OS project detected. Proceeding with full validation."
    Write-Host ""

    # ================= STEP 3: SCAN =================
    Write-Host "== Scanning against frozen baseline =="

    $missingDirs = New-Object System.Collections.Generic.List[string]
    $missingFiles = New-Object System.Collections.Generic.List[object]
    $structuralDrift = New-Object System.Collections.Generic.List[string]
    $nonEmptyPlaceholders = New-Object System.Collections.Generic.List[string]
    $unrecognizedItems = New-Object System.Collections.Generic.List[string]

    foreach ($d in $Manifest.directories) {
        $full = Join-RelPath $TargetRoot $d
        if (-not (Test-Path -LiteralPath $full -PathType Container)) {
            $missingDirs.Add($d)
        }
        elseif (Test-IsReparsePoint $full) {
            $missingDirs.Add("$d (is a reparse point, not a real directory)")
        }
    }

    foreach ($f in $Manifest.files) {
        $full = Join-RelPath $TargetRoot $f.path
        if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
            $missingFiles.Add($f)
            continue
        }
        if ($f.tier -eq 'content-mutable') {
            continue
        }
        if (Test-IsReparsePoint $full) {
            if ($f.tier -eq 'structural') { $structuralDrift.Add("$($f.path) (is a reparse point, expected a regular file)") }
            else { $nonEmptyPlaceholders.Add("$($f.path) (is a reparse point, expected an empty regular file)") }
            continue
        }
        if ($f.tier -eq 'structural') {
            $hash = Get-NormalizedHash $full
            if ($hash -ne $f.sha256_normalized) { $structuralDrift.Add($f.path) }
        }
        elseif ($f.tier -eq 'placeholder') {
            $len = (Get-Item -LiteralPath $full -Force).Length
            if ($len -ne 0) { $nonEmptyPlaceholders.Add($f.path) }
        }
    }

    foreach ($ap in $Manifest.anti_pattern_paths) {
        $full = Join-RelPath $TargetRoot $ap
        if (Test-Path -LiteralPath $full) { $unrecognizedItems.Add($ap) }
    }

    $totalIssues = $missingDirs.Count + $missingFiles.Count + $structuralDrift.Count + $nonEmptyPlaceholders.Count + $unrecognizedItems.Count

    # ================= STEP 4: REPORT =================
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# AIS-OS Structure Validation Report")
    $lines.Add("Target: $TargetRoot")
    $lines.Add("")

    if ($totalIssues -eq 0) {
        $lines.Add("PASS: project fully conforms to the frozen AIS-OS baseline.")
        $lines.Add("All 9 baseline directories present.")
        $lines.Add("All $($Manifest.files.Count) baseline files present.")
        $lines.Add("No structural drift, no non-empty placeholders, no unrecognized anti-pattern items.")
    }
    else {
        if ($missingDirs.Count -gt 0) {
            $lines.Add("## Missing directories")
            foreach ($d in $missingDirs) {
                $lines.Add("- $d")
                $lines.Add("  fix: create directory '$d'")
            }
            $lines.Add("")
        }
        if ($missingFiles.Count -gt 0) {
            $lines.Add("## Missing files")
            foreach ($mf in $missingFiles) {
                $lines.Add("- $($mf.path) (tier: $($mf.tier))")
                if ($mf.tier -eq 'content-mutable') {
                    $lines.Add("  fix: create '$($mf.path)' -- populate via /onboard, or copy the blank template from this skill's templates/$($mf.path)")
                }
                elseif ($mf.tier -eq 'placeholder') {
                    $lines.Add("  fix: create an empty (zero-byte) file at '$($mf.path)'")
                }
                else {
                    $lines.Add("  fix: restore '$($mf.path)' from this skill's templates/$($mf.path)")
                }
            }
            $lines.Add("")
        }
        if ($structuralDrift.Count -gt 0) {
            $lines.Add("## Structural drift")
            foreach ($sd in $structuralDrift) {
                $lines.Add("- $sd")
                $lines.Add("  fix: content differs from the frozen baseline -- restore from this skill's templates/$sd")
            }
            $lines.Add("")
        }
        if ($nonEmptyPlaceholders.Count -gt 0) {
            $lines.Add("## Non-empty placeholders")
            foreach ($ph in $nonEmptyPlaceholders) {
                $lines.Add("- $ph")
                $lines.Add("  fix: '$ph' should be exactly zero bytes -- clear its contents")
            }
            $lines.Add("")
        }
        if ($unrecognizedItems.Count -gt 0) {
            $lines.Add("## Unrecognized items")
            foreach ($u in $unrecognizedItems) {
                $lines.Add("- $u")
                $lines.Add("  fix: remove or rename '$u' -- not part of the AIS-OS baseline or a documented growth pattern (see EXPANSIONS.md)")
            }
            $lines.Add("")
        }
        $lines.Add("Total issues: $totalIssues")
    }

    $reportText = [string]::Join("`n", $lines)
    Write-Host ""
    Write-Host $reportText
    Write-Host ""

    if ($SaveReport) {
        $reportDir = Join-Path $TargetRoot 'validations'
        if (-not (Test-Path -LiteralPath $reportDir)) {
            New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
        }
        $dateStr = Get-Date -Format 'yyyy-MM-dd'
        $baseName = "validate-$dateStr"
        $candidate = Join-Path $reportDir "$baseName.md"
        $suffix = 2
        while (Test-Path -LiteralPath $candidate) {
            $candidate = Join-Path $reportDir "$baseName-$suffix.md"
            $suffix++
        }
        Set-Content -LiteralPath $candidate -Value $reportText -Encoding UTF8 -NoNewline
        Write-Host "REPORT_SAVED: $candidate"
    }

    if ($totalIssues -eq 0) { exit 0 } else { exit 1 }
}
catch {
    Write-Host "FAIL: unexpected error during scan: $($_.Exception.Message)"
    exit 20
}
