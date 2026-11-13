& {
    try {
        Stop-Service -Name wuauserv -Force -ErrorAction Stop
        Stop-Service -Name bits -Force -ErrorAction Stop

        # Use robocopy to mirror an empty dir over top of folder
        # Prevents filepath length errors
        $EmptyDir = New-Item -Path "$env:TEMP\EmptyFolder" -ItemType Directory -Force -ErrorAction Stop
        robocopy $EmptyDir.FullName "C:\Windows\SoftwareDistribution\Download" /MIR /R:0 /W:0
        Remove-Item $EmptyDir.FullName -Force -ErrorAction Stop

        Start-Service -Name wuauserv -ErrorAction Stop
        Start-Service -Name bits -ErrorAction Stop
        Write-Host "Update cache cleared" -ForegroundColor Green
    }
    catch {
        Write-Host "Update cache failed to clear" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}