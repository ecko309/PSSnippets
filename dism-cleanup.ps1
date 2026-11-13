& {
    $Analyze = dism.exe /online /cleanup-Image /AnalyzeComponentStore # Analyze for components to cleanup

    $Output = [pscustomobject]@{
        OverallSuccess     = $false
        AnalyzeSuccess     = [bool]$(($Analyze | Out-String) -match "The operation completed successfully")
        CleanupRecommended = [bool]$(($Analyze | Out-String) -match "Component Store Cleanup Recommended : Yes")
        CleanupSuccess     = $null
        Message            = "Dism log saved to: '$env:SystemRoot\Logs\Dism\dism.log'"
    }

    if ($Output.AnalyzeSuccess -and $Output.CleanupRecommended) { 
        $Cleanup = dism.exe /online /cleanup-Image /StartComponentCleanup # /ResetBase <- Removes capability to roll back updates
        $Output.CleanupSuccess = [bool]$($LASTEXITCODE -eq 0)
        $Output.OverallSuccess = $Output.CleanupSuccess
    }
    elseif ($Output.AnalyzeSuccess) {
        $Output.CleanupSuccess = "N/A"
        $Output.OverallSuccess = $true
    }

    return $Output
}