# Description: Boxstarter Script
#
# Install boxstarter:
# 	. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
#
# You might need to set: Set-ExecutionPolicy RemoteSigned
#
# Run this boxstarter by calling the following from an **elevated** command-prompt or open the url from Edge:
# 	start http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/bltavares/windows-devbox/master/install.ps1
# OR
# 	Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/bltavares/windows-devbox/master/install.ps1 -DisableReboots
#
# Learn more: http://boxstarter.org/Learn/WebLauncher


Disable-UAC
$ConfirmPreference = "None" #ensure installing powershell modules don't prompt on needed dependencies

# Remove extra apps

function removeApp {
    Param ([string]$appName)
    Write-Output "Trying to remove $appName"
    Get-AppxPackage $appName -AllUsers | Remove-AppxPackage
    Get-AppXProvisionedPackage -Online | Where DisplayNam -like $appName | Remove-AppxProvisionedPackage -Online
}

$applicationList = @(
  "*MarchofEmpires*"
  "*Autodesk*"
  "*BubbleWitch*"
  "king.com*"
  "G5*"
  "*Facebook*"
  "*Keeper*"
  "*Plex*"
  "*.EclipseManager"
  "ActiproSoftwareLLC.562882FEEB491" # Code Writer
  "*DolbyAccess*"
  "*DisneyMagicKingdom*"
  "*HiddenCityMysteryofShadows*"
);

foreach ($app in $applicationList) {
    removeApp $app
}

# Windows setup
## Show hidden files, Show protected OS files, Show file extensions
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

## will expand explorer to the actual folder you're in
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1

## adds things back in your left pane like recycle bin
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1

## opens PC to This PC, not quick access
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1

## Disable Quick Access: Recent Files
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 0

## Disable Quick Access: Frequent Folders
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 0

## Dock
Set-TaskbarOptions -Size Small -Dock Bottom -Combine Always -Lock

## Privacy: Let apps use my advertising ID: Disable
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
    New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo | Out-Null
}
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0

## WiFi Sense: HotSpot Sharing: Disable
If (-Not (Test-Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
    New-Item -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting | Out-Null
}
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Name value -Type DWord -Value 0

## WiFi Sense: Shared HotSpot Auto-Connect: Disable
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots -Name value -Type DWord -Value 0

## Start Menu: Disable Bing Search Results
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0

## Turn off People in Taskbar
If (-Not (Test-Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
    New-Item -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People | Out-Null
}
Set-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name PeopleBand -Type DWord -Value 0

# Docker
choco install -y Microsoft-Hyper-V-All --source="'windowsFeatures'"
Enable-WindowsOptionalFeature -Online -FeatureName containers -All
choco install -y docker-for-windows

# WSL
choco install -y Microsoft-Windows-Subsystem-Linux --source="'windowsfeatures'"
choco install -y wsl-debiangnulinux
choco install -y vcxsrv
debian.exe run apt update
debian.exe run apt upgrade -y

# Apps
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"

$applicationList = @(
  "firefox"
  "terraform"
  "vscode"
  "7zip"
  "keepass"
  "keepass-keepasshttp"
  "keepass-plugin-readablepassphrasegen"
  "synctrayzor"
  "wsltty"
  "zerotier-one"
  "vlc"
);

foreach ($app in $applicationList) {
    choco install -y $app
}

# Rust
choco install -y vcbuildtools
choco install -y rustup --pre

Update-SessionEnvironment #refreshing env due to Git install
RefreshEnv

#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
