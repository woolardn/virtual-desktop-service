# Scripted Event Example, Uninstall Google Chrome
#
# Example Script Repository Settings
# Name: UninstallEzeepPrintApp
# Include Script File: Use Script File
# Import Script, Select a File: UninstallEzeepPrintApp.ps1
# Script Usage: Use this script as an argument for an executable.
# Execute With: C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe
# Arguments: -file %scriptname%
#
# Example Activity Settings
# Name: UninstallEzeepPrintApp
# Script: UninstallEzeepPrintApp
# Enabled
# Trigger On: Application Install
# Target Settings, Application: Ezeep Print App
# Application Icon Path: \\shortcuts\Printer Self Service.lnk
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
    Set-ExecutionPolicy Bypass -Scope Process -Force; iwr https://chocolatey.org/Uninstall.ps1 -UseBasicParsing | iex
    $ChocoInstalled = Get-ChocoInstalled
}

if($ChocoInstalled) {
    choco uninstall cjaezeep_print_app -y --force
} else {
    Write-Error "Chocolatey could not be detected."
}