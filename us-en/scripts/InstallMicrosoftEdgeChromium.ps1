# Scripted Event Example, Install Microsoft Edge Chromium
#
# Example Script Repository Settings
# Name: InstallMicrosoftEdgeChromium
# Include Script File: Use Script File
# Import Script, Select a File: InstallMicrosoftEdgeChromium.ps1
# Script Usage: Use this script as an argument for an executable.
# Execute With: C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe
# Arguments: -file %scriptname%
#
# Example Activity Settings
# Name: InstallMicrosoftEdgeChromium
# Script: InstallMicrosoftEdgeChromium
# Enabled
# Trigger On: Application Install
# Target Settings, Application: Microsoft Edge Chromium
# Application Icon Path: \\shortcuts\Microsoft Edge.lnk
#


# Make sure Chocolatey is installed.
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
    choco install microsoft-edge -y --force
} else {
    Write-Error "Chocolatey could not be detected."
}