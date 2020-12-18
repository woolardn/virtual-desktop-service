# Scripted Event Example, Install Nvidia Grid Drivers
#
# Example Script Repository Settings
# Name: InstallNvidiaGridDrivers
# Include Script File: Use Script File
# Import Script, Select a File: InstallNvidiaGridDrivers.ps1
# Script Usage: Use this script as an argument for an executable.
# Execute With: C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe
# Arguments: -file %scriptname%
#
# Example Activity Settings
# Name: InstallNvidiaGridDrivers
# Script: InstallNvidiaGridDrivers
# Enabled
# Trigger On: Manual
# Target Settings, TargetedServers
#


Function Get-ChocoInstalled {

    $result = $true

    Try {
        $version = choco -v
    } Catch {
        $result = $false
    }
    
    Return $result
}

$ChocoInstalled = Get-ChocoInstalled

if(-not $ChocoInstalled) {
    Set-ExecutionPolicy Bypass -Scope Process -Force; iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
    $ChocoInstalled = Get-ChocoInstalled
}

if($ChocoInstalled) {
    choco install cjanvidia_grid -y --force
} else {
    Write-Error "Chocolatey could not be detected."
}