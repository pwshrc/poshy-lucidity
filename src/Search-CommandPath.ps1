#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


<#
.SYNOPSIS
    Searches for the specified command in the current session's command path.
.PARAMETER Name
    The name of the command to search for.
.PARAMETER All
    If specified, returns all commands with the specified name in the current session's command path.
.NOTES
    Similar to *nix `which` or `where` commands.
.OUTPUTS
    System.String
.EXAMPLE
    Search-CommandPath -Name "notepad"
.EXAMPLE
    Search-CommandPath -Name "notepad" -All
#>
function Search-CommandPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string[]] $Name,

        [Parameter(Mandatory=$false, Position=1)]
        [switch] $All
    )

    $command_types = @("Application", "ExternalScript")
    if ($All) {
        $command_types += "All"
    }

    $command = Get-Command -Name $Name -ErrorAction SilentlyContinue -CommandType $command_types
    if (-not $command) {
        return $null
    }

    if (-not $All) {
        return $command | Select-Object -First 1 -ExpandProperty Source
    }
    else {
        return $command | Select-Object -ExpandProperty Source
    }
}
