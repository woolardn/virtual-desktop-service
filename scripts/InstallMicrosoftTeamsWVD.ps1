# Scripted Event Example, Install Microsoft Teams
#
# Example Script Repository Settings
# Name: InstallMicrosoftTeamsWVD
# Include Script File: Use Script File
# Import Script, Select a File: InstallMicrosoftTeamsWVD.ps1
# Script Usage: Use this script as an argument for an executable.
# Execute With: C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe
# Arguments: -file %scriptname%
#
# Example Activity Settings
# Name: InstallMicrosoftTeamsWVD
# Script: InstallMicrosoftTeamsWVD
# Enabled
# Trigger On: Application Install
# Target Settings, Application: Microsoft Teams WVD
# No Desktop Icon.
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


$Error.Clear()
Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Teams" -ErrorAction SilentlyContinue
if($Error[0] -ne $null) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Teams"
}

$Error.Clear()
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Teams" -Name "IsWVDEnvironment" -ErrorAction SilentlyContinue
if($Error[0] -ne $null) {
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Teams" -Name "IsWVDEnvironment" -Value 1 -PropertyType DWORD
}


if($ChocoInstalled) {
    choco install cjawebrtcsvc -y --force
    choco install microsoft-teams.install -y --force
} else {
    Write-Error "Chocolatey could not be detected."
}


$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Teams.lnk")
$shortcut.TargetPath = '%LocalAppData%\Microsoft\Teams\Update.exe'
$shortcut.Arguments = '--processStart "Teams.exe"'
$shortcut.WorkingDirectory = '%LocalAppData%\Microsoft\Teams'
$shortcut.Save()