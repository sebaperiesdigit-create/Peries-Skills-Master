<#
Administrator identity correction. This is a self-attestation +
audit-log control, not a real authorization check -- Claude Code
has no identity backend to verify the acting administrator against.
Only ever touches the employee config and the audit log; never
rewrites past daily entry files.
#>
param(
    [Parameter(Mandatory = $true)][string]$OldEmployeeId,
    [Parameter(Mandatory = $true)][string]$NewEmployeeId,
    [Parameter(Mandatory = $true)][string]$NewEmployeeName,
    [Parameter(Mandatory = $true)][string]$AdminName,
    [Parameter(Mandatory = $true)][string]$Reason,
    [string]$ConfigPath = "output/daily-work-tracker/_config/employee.json",
    [string]$AuditPath = "output/daily-work-tracker/_admin-audit-log.md"
)

if (-not (Test-Path $ConfigPath)) {
    Write-Error "No employee config found at $ConfigPath. Run setup first."
    exit 1
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

if ($config.employeeId -ne $OldEmployeeId) {
    Write-Error "Old employee ID '$OldEmployeeId' does not match current config ('$($config.employeeId)'). Aborting without changes."
    exit 1
}

$previousId = $config.employeeId
$previousName = $config.employeeName

$config.employeeId = $NewEmployeeId
$config.employeeName = $NewEmployeeName
$config | ConvertTo-Json | Set-Content -Path $ConfigPath -Encoding utf8

$auditDir = Split-Path -Path $AuditPath -Parent
if ($auditDir -and -not (Test-Path $auditDir)) {
    New-Item -ItemType Directory -Path $auditDir -Force | Out-Null
}

$timestamp = Get-Date -Format "o"
$entry = @"

## $timestamp
- Administrator: $AdminName
- Reason: $Reason
- Previous: $previousName ($previousId)
- New: $NewEmployeeName ($NewEmployeeId)
"@
Add-Content -Path $AuditPath -Value $entry -Encoding utf8

Write-Output "IDENTITY_UPDATED"
