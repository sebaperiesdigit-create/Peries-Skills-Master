<#
Initializes the local marker directory, prunes markers older than 90 days,
and reports whether employee config exists. Read-only with respect to
output/daily-work-tracker/ — never creates or modifies config here.
#>
param(
    [string]$ConfigPath = "output/daily-work-tracker/_config/employee.json"
)

$markerRoot = Join-Path $env:LOCALAPPDATA "daily-work-tracker\markers"
if (-not (Test-Path $markerRoot)) {
    New-Item -ItemType Directory -Path $markerRoot -Force | Out-Null
}

$cutoff = (Get-Date).AddDays(-90)
Get-ChildItem -Path $markerRoot -Recurse -Filter "*.done" -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -lt $cutoff } |
    Remove-Item -Force -ErrorAction SilentlyContinue

$configExists = Test-Path $ConfigPath

$result = [ordered]@{
    MarkerRoot   = $markerRoot
    ConfigPath   = $ConfigPath
    ConfigExists = $configExists
    EmployeeId   = $null
    EmployeeName = $null
}

if ($configExists) {
    try {
        $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
        $result.EmployeeId = $config.employeeId
        $result.EmployeeName = $config.employeeName
    } catch {
        $result.ConfigExists = $false
    }
}

$result | ConvertTo-Json
