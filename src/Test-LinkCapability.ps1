#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


<#
.SYNOPSIS
    Tests which filesystem link capabilities are supported by the current session.
.NOTES
    See: https://docs.microsoft.com/en-us/windows/win32/fileio/hard-links-and-junctions
#>
function Test-LinkCapability() {
    param (
        [Parameter(Mandatory = $false)]
        [switch] $NoCache
    )

    [PSCustomObject] $cached_result = Get-Variable -Name "Test-LinkCapability" -Scope Global -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Value
    if (-not $NoCache -and $cached_result) {
        return $cached_result
    } elseif ($cached_result) {
        Remove-Variable -Name "Test-LinkCapability" -Scope Global -ErrorAction SilentlyContinue
    }

    [hashtable] $capabilities = @{
        "HardLinks" = $null
        "Junctions" = $null
        "SymbolicLinks" = $null
    }

    $testFile = Join-Path -Path $env:TEMP -ChildPath "test-file"
    $testDir = Join-Path -Path $env:TEMP -ChildPath "test-dir"
    $testJunctionFile = Join-Path -Path $env:TEMP -ChildPath "test-junction-file"
    $testJunctionDir = Join-Path -Path $env:TEMP -ChildPath "test-junction-dir"
    $testSymlinkFile = Join-Path -Path $env:TEMP -ChildPath "test-symlink-file"
    $testSymlinkDir = Join-Path -Path $env:TEMP -ChildPath "test-symlink-dir"
    $testHardLinkFile = Join-Path -Path $env:TEMP -ChildPath "test-hardlink-file"
    $testHardLinkDir = Join-Path -Path $env:TEMP -ChildPath "test-hardlink-dir"

    [string[]] $allPossibleArtifacts = @( $testFile, $testDir, $testJunctionFile, $testJunctionDir, $testSymlinkFile, $testSymlinkDir, $testHardLinkFile, $testHardLinkDir )

    $allPossibleArtifacts | ForEach-Object {
        if (Test-Path -Path $_ -ErrorAction SilentlyContinue) {
            Remove-Item -Path $_ -Force
        }
    }

    try {
        New-Item -Path $testFile -ItemType File -ErrorAction Stop | Out-Null
        New-Item -Path $testDir -ItemType Directory -ErrorAction Stop | Out-Null

        try {
            New-Item -Path $testJunctionDir -ItemType Junction -Target $testDir -ErrorAction Stop | Out-Null
            $capabilities["Junctions"] = ($capabilities["Junctions"] ?? @()) + @("Directories")
        } catch {
            # Ignore
        }

        try {
            New-Item -Path $testSymlinkDir -ItemType SymbolicLink -Target $testDir -ErrorAction Stop | Out-Null
            $capabilities["SymbolicLinks"] = ($capabilities["SymbolicLinks"] ?? @()) + @("Directories")
        } catch {
            # Ignore
        }

        try {
            New-Item -Path $testHardLinkDir -ItemType HardLink -Target $testDir -ErrorAction Stop | Out-Null
            $capabilities["HardLinks"] = ($capabilities["HardLinks"] ?? @()) + @("Directories")
        } catch {
            # Ignore
        }

        try {
            New-Item -Path $testJunctionFile -ItemType Junction -Target $testFile -ErrorAction Stop | Out-Null
            $capabilities["Junctions"] = ($capabilities["Junctions"] ?? @()) + @("Files")
        } catch {
            # Ignore
        }

        try {
            New-Item -Path $testSymlinkFile -ItemType SymbolicLink -Target $testFile -ErrorAction Stop | Out-Null
            $capabilities["SymbolicLinks"] = ($capabilities["SymbolicLinks"] ?? @()) + @("Files")
        } catch {
            # Ignore
        }

        try {
            New-Item -Path $testHardLinkFile -ItemType HardLink -Target $testFile -ErrorAction Stop | Out-Null
            $capabilities["HardLinks"] = ($capabilities["HardLinks"] ?? @()) + @("Files")
        } catch {
            # Ignore
        }

        [PSCustomObject] $result = [PSCustomObject]$capabilities
        # If all members are empty, convert to false.
        if (($null -eq $result.PSObject.Properties.Value) -or ($result.PSObject.Properties.Value -eq @())) {
            $result = $false
        }

        if (-not $NoCache) {
            Set-Variable -Name "Test-LinkCapability" -Value $result -Scope Global -Option Constant -ErrorAction SilentlyContinue
        }
        return $result
    } finally {
        $allPossibleArtifacts | ForEach-Object {
            if (Test-Path -Path $_ -ErrorAction SilentlyContinue) {
                Remove-Item -Path $_ -Force -ErrorAction Continue
            }
        }
    }
}
