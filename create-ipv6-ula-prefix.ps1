& { # Script block to allow to paste into terminal
    $bytes = [byte[]]::new(5) # 40 bits
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
    $rng.GetBytes($bytes)
    $R = "FD$(([System.BitConverter]::ToString($bytes)) -replace "-")"
    $ULA = "$(([regex]::Matches($R, '.{1,4}')).Value -join ':')" # /48 for global prefix, /64 for local
    $ULA = $ULA.ToLowerInvariant().trim()

    Write-Host "$ULA::/48"
}

<#
    ########################################################################################################
    ULA prefix is locally significant
    Block is fc::/8 (rfc4193)
    Usable block is fd::/8 (rfc4193)

    |  8 bits  |       40 bits          |    16 bits    |         64 bits        |
    |  Prefix  | Global ID (Org Unique) |   Subnet ID   |      Interface ID       |
    +----------+------------------------+---------------+-------------------------+
    |    fd    |   xx:xxxx:xxxx        |     yyyy       |   zzzz:zzzz:zzzz:zzzz   |
    +----------+------------------------+---------------+-------------------------+
    |<------------ /48 ---------------->|               |
    |<--------------------- /64 ----------------------->|

    # Very little chance of ULA /48 prefixes matching across orgs
    ########################################################################################################
#>