& {
    $x32 = Join-Path ${env:ProgramFiles(x86)} "Netskope\stagent\nsdiag.exe"
    $x64 = Join-Path ${env:ProgramFiles} "Netskope\stagent\nsdiag.exe"

    if (Test-Path $x32) { $exe = $x32 }
    elseif (Test-Path $x64) { $exe = $x64 }
    else { throw "File not found" }

    $exe
    & $exe "-n"
    & $exe "-f"
    & $exe "--check-dc"
}