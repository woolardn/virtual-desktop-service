# Scripted Event Example, Uninstall Microsoft Office 365
#
# Example Script Repository Settings
# Name: UninstallMicrosoftOffice365
# Include Script File: Use Script File
# Import Script, Select a File: UninstallMicrosoftOffice365.ps1
# Script Usage: Use this script as an argument for an executable.
# Execute With: C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe
# Arguments: -file %scriptname%
#
# Example Activity Settings
# Name: UninstallMicrosoftOffice365
# Script: UninstallMicrosoftOffice365
# Enabled
# Trigger On: Application Uninstall
# Target Settings, Application: Microsoft Office
# Application Icon Path: \\folder\Microsoft Office
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


# Create a temporary source directory for install.
$InstallSourcePath = "C:\choco"
New-Item -ItemType Directory -Path $InstallSourcePath -Force -ErrorAction SilentlyContinue

# Create an install configuration file.
$XMLConfigFile = "$InstallSourcePath\uio365conf.xml"

$XMLConfig = @"
<Configuration>
    <!--Uninstall complete Office 365-->
    <Display Level="None" AcceptEULA="TRUE" />
    <Logging Level="Standard" Path="%temp%" />
    <Remove All="TRUE" />
</Configuration>
"@

$XMLConfig | Out-File -FilePath $XMLConfigFile


if($ChocoInstalled) {
    choco install office365proplus -y --force --params "/ConfigPath:$($XMLConfigFile)"
    choco uninstall office365proplus -y -force
    $startmenu = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'
    $microsoftoffice = "$($startmenu)\Microsoft Office"
    Remove-Item -Path $microsoftoffice -Recurse -Force
} else {
    Write-Error "Chocolatey could not be detected."
}