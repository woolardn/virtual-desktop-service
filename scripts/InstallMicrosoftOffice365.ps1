# Scripted Event Example, Install Microsoft Office 365
#
# Example Script Repository Settings
# Name: InstallMicrosoftOffice365
# Include Script File: Use Script File
# Import Script, Select a File: InstallMicrosoftOffice365.ps1
# Script Usage: Use this script as an argument for an executable.
# Execute With: C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe
# Arguments: -file %scriptname%
#
# Example Activity Settings
# Name: InstallMicrosoftOffice365
# Script: InstallMicrosoftOffice365
# Enabled
# Trigger On: Application Install
# Target Settings, Application: Microsoft Office
# Application Icon Path: \\folders\Microsoft Office
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
$XMLConfigFile = "$InstallSourcePath\o365conf.xml"

$XMLConfig = @"
<Configuration ID="8a7f7b86-ef81-4793-acf3-c203ee97ed8b" DeploymentConfigurationID="00000000-0000-0000-0000-000000000000">
  <Add OfficeClientEdition="32" Channel="Broad" ForceUpgrade="TRUE">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-us" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="Teams" />
    </Product>
  </Add>
  <Property Name="SharedComputerLicensing" Value="1" />
  <Property Name="PinIconsToTaskbar" Value="TRUE" />
  <Property Name="SCLCacheOverride" Value="0" />
  <Updates Enabled="TRUE" />
  <Display Level="None" AcceptEULA="TRUE" />
  <Logging Level="Standard" Path="$InstallSourcePath" />
</Configuration>
"@

$XMLConfig | Out-File -FilePath $XMLConfigFile


if($ChocoInstalled) {
    choco install office365proplus -y --force --params "/ConfigPath:$($XMLConfigFile)"
    
    # Place shortcuts in Microsoft Office subfolder.
    $startmenu = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'
    $microsoftoffice = "$($startmenu)\Microsoft Office"
    
    New-Item -ItemType Directory -Path $microsoftoffice -Force -ErrorAction SilentlyContinue

    $officeapps = ("Access.lnk","Excel.lnk","OneNote 2016.lnk","Outlook.lnk","PowerPoint.lnk","Publisher.lnk","Word.lnk")
  
    foreach ($child in Get-ChildItem $startmenu) {
        if ($officeapps.Contains($child.Name)) {
            Copy-Item "$startmenu\$($child.Name)" "$microsoftoffice\$($child.Name)" -Force
        }  
    }

} else {
    Write-Error "Chocolatey could not be detected."
}