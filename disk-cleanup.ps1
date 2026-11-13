& {
    $BaseRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\*"
    Set-ItemProperty -Path $BaseRegPath -Name "StateFlags0099" -Type DWORD -Value 2 -ErrorAction Stop
    $CleanProcess = Start-Process -FilePath "$env:SystemRoot\System32\cleanmgr.exe" -ArgumentList "/sagerun:99" -WindowStyle Hidden -PassThru -Wait
    Remove-ItemProperty -Path $BaseRegPath -Name "StateFlags0099" -ErrorAction SilentlyContinue
    return [bool]($CleanProcess.ExitCode -eq 0)
}