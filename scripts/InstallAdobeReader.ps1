# Scripted Event Example, Install Adobe Reader
#
# Example Script Repository Settings
# Name: InstallAdobeReader
# Include Script File: Use Script File
# Import Script, Select a File: InstallAdobeReader.ps1
# Script Usage: Use this script as an argument for an executable.
# Execute With: C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe
# Arguments: -file %scriptname%
#
# Example Activity Settings
# Name: InstallAdobeReader
# Script: InstallAdobeReader
# Enabled
# Trigger On: Application Install
# Target Settings, Application: Adobe Reader
# Application Icon Path: \\shortcuts\Acrobat Reader DC.lnk
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
    choco install adobereader -y --force
} else {
    Write-Error "Chocolatey could not be detected."
}