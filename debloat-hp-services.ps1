#Requires -PSEdition Core

$servicesToRemove = @(
    "HPAppHelperCap",                 # Backend component for HP Support Assistant apps
    "HPDiagsCap",                     # Backend component for HP hardware diagnostics
    "HPNetworkCap",                   # Backend component for HP network management tools
    "hpsvcsscan",                     # Background scanner for HP-related updates and prompts
    "HPSysInfoCap",                   # Backend component for HP system information gathering
    "HpTouchpointAnalyticsService",   # HP telemetry/data collection (notorious for high CPU/RAM usage)
    "LanWlanWwanSwitchingServiceDSU"  # Automatically disables Wi-Fi when an Ethernet cable is plugged in
)

$servicesToDisableAutostart = @(
    "SFUService"                      # System Firmware Update (handles BIOS updates through Windows)
)

foreach ($service in $servicesToRemove) {
    if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
        try {
            Stop-Service -Name $service -Force -ErrorAction Stop
            Set-Service -Name $service -StartupType Disabled
            Remove-Service -Name $service -Confirm:$false -ErrorAction Stop
            Write-Host "Removed: $service" -ForegroundColor Red
        }
        catch {
            Write-Host "Failed to remove: $service`n$($_.Exception.Message)" -ForegroundColor DarkRed
        }
    }
    else {
        Write-Host "N/A: $service" -ForegroundColor Gray
    }
}

foreach ($service in $servicesToDisableAutostart){
    if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
        try {
            Stop-Service -Name $service -Force -ErrorAction Stop
            Set-Service -Name $service -StartupType Manual 
            Write-Host "Disabled auto-start: $service" -ForegroundColor Yellow
        }
        catch {
            Write-Host "Failed to disabled auto-start: $service`n$($_.Exception.Message)" -ForegroundColor DarkRed
        }
    }
    else {
        Write-Host "N/A: $service" -ForegroundColor Gray
    }
}