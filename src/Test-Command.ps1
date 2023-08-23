#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


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
