$query = "*Global*Protect*.msi" # Query to match
$skipDirs = @("Windows", "`$Recycle.Bin", "System Volume Information") # Exclude dir

Get-ChildItem -Path C:\ -Directory -Force -ErrorAction SilentlyContinue | 
    Where-Object { $_.Name -notin $skipDirs } | 
    ForEach-Object {
        Get-ChildItem -Path $_.FullName -Filter $query  -Recurse -Force -ErrorAction SilentlyContinue
    } | 
    Select-Object -ExpandProperty FullName