Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions
Enable-RemoteDesktop
Disable-UAC
Disable-InternetExplorerESC
Set-StartScreenOptions -EnableBootToDesktop -DisableDesktopBackgroundOnStart -DisableShowStartOnActiveScreen -DisableShowAppsViewOnStartScreen
Disable-GameBarTips
Disable-BingSearch
Set-TaskbarSmall
New-Item -ItemType Directory "$env:USERPROFILE\Desktop\Master Control.{ED7BA470-8E54-465E-825C-99712043E01C}"
