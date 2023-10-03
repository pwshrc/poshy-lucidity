#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


<#
.SYNOPSIS
    Tests whether or not the specified command exists in the current session.
.PARAMETER Name
    The name of the command to test for.
.PARAMETER ExecutableOnly
    If specified, only indicates success if the command is an executable.
.OUTPUTS
    System.Boolean
.NOTES
    Similar to using *nix `type` or `typeset` commands with the `-t` option.
#>
function Test-Command() {
    param(
        [Parameter(Mandatory = $true)]
        [string[]] $Name,

        [Parameter(Mandatory = $false)]
        [switch] $ExecutableOnly
    )
    if (-not $ExecutableOnly) {
        return ($null -ne (Get-Command -ErrorAction SilentlyContinue $Name))
    } else {
        $command_types = @("Application", "ExternalScript")
        return ($null -ne (Get-Command -ErrorAction SilentlyContinue $Name -CommandType $command_types))
    }
}
