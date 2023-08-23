#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


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
