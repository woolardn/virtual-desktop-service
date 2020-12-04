# Scripted Event Example, Uninstall Microsoft OneDrive
#
# Example Script Repository Settings
# Name: UninstallMicrosoftOneDrive
# Include Script File: Use Script File
# Import Script, Select a File: UninstallMicrosoftOneDrive.ps1
# Script Usage: Use this script as an argument for an executable.
# Execute With: C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe
# Arguments: -file %scriptname%
#
# Example Activity Settings
# Name: UninstallMicrosoftOneDrive
# Script: UninstallMicrosoftOneDrive
# Enabled
# Trigger On: Application Install
# Target Settings, Application: Microsoft OneDrive
# Application Icon Path: \\shortcuts\OneDrive.lnk
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
    choco uninstall cjamicrosoft_onedrive -y --force
} else {
    Write-Error "Chocolatey could not be detected."
}