################################################################################################
# Get ccm cache sizes
$MaxSizeMB = (Get-CimInstance -Namespace "root\ccm\SoftMgmtAgent" -ClassName "CacheConfig").Size

$UsedSizeKB = (Get-CimInstance -Namespace "root\ccm\SoftMgmtAgent" -ClassName "CacheInfoEx" | Measure-Object -Property ContentSize -Sum).Sum
$UsedSizeMB = [math]::Round($UsedSizeKB / 1024, 2)

Write-Host "CCMCache Sizes" -ForegroundColor Green
[PSCustomObject]@{
    UsedSize = "$UsedSizeMB MB"
    MaxSize  = "$MaxSizeMB MB"
    FreeSize = "$([math]::Round($MaxSizeMB - $UsedSizeMB, 2)) MB"
} | Format-List
 
################################################################################################
# Reset CCM cache
& {
    try {
        $UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
        $Cache = $UIResourceMgr.GetCacheInfo()
        $Cache.GetCacheElements() | ForEach-Object {
            $Cache.DeleteCacheElement($_.CacheElementID)
        }
        Write-Host "CCMCache cleared" -ForegroundColor Green
    }
    catch {
        Write-Host "CCMCache failed to clear" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}

################################################################################################
# Set ccm cache max size
$NewCacheSizeMB = 10240 # MB

$CCM = New-Object -ComObject "UIResource.UIResourceMgr"
$CacheInfo = $CCM.GetCacheInfo()
$CacheInfo.TotalSize = $NewCacheSizeMB

################################################################################################