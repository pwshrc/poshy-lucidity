
#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


<#
.SYNOPSIS
    Tests whether or not the current session is interactive.
.OUTPUTS
    System.Boolean
#>
function Test-SessionInteractivity {
    [CmdletBinding()]
    param()

    if (-not [Environment]::UserInteractive) {
        return $false
    }

    [string[]] $pwshArgs = [Environment]::GetCommandLineArgs()

    if ($pwshArgs -contains '-NonInteractive') {
        return $false
    } elseif ($pwshArgs -contains '-Command') {
        return $false
    } elseif ($pwshArgs -contains '-EncodedCommand') {
        return $false
    } elseif ($pwshArgs -contains '-File') {
        return $false
    } elseif ($pwshArgs -contains '-NoWindow') {
        return $false
    }

    return $true
}
