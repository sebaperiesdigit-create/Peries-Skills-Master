<#
Reads or writes a completion marker for one employee/date.
Markers are ephemeral, machine-local runtime state only —
the daily entry file in output/daily-work-tracker/ is always
the authoritative record, never the marker.
#>
param(
    [Parameter(Mandatory = $true)][string]$EmployeeId,
    [Parameter(Mandatory = $true)][string]$Date,
    [switch]$MarkComplete
)

$markerDir = Join-Path $env:LOCALAPPDATA "daily-work-tracker\markers\$EmployeeId"
if (-not (Test-Path $markerDir)) {
    New-Item -ItemType Directory -Path $markerDir -Force | Out-Null
}

$markerPath = Join-Path $markerDir "$Date.done"

if ($MarkComplete) {
    Get-Date -Format "o" | Set-Content -Path $markerPath -Encoding utf8
    Write-Output "MARKED_COMPLETE:$markerPath"
} elseif (Test-Path $markerPath) {
    Write-Output "COMPLETE:$markerPath"
} else {
    Write-Output "INCOMPLETE"
}
