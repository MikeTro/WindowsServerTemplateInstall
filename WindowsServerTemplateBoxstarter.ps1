######## windows server template boxstarter script ########

###############
#### NOTES ####
###############

## After a restart/reconnect, even though it shows the login screen, boxstarter is still working

### NOTES when kicking off remotely from host to VM, fails on Configuring CredSSP settings
## check http://blogs.technet.com/b/heyscriptingguy/archive/2012/12/30/understanding-powershell-remote-management.aspx

### MISC NOTES
## Boxstarter repeats the _entire_ script after restart. For already-installed packages, Chocolatey will take a couple seconds each to verify. This can get tedious, so consider putting packages that require a reboot near the beginning of the script.
## Boxstarter automatically disables windows update so you don't need to do that at the beginning of the script.
## you still want to Restart or Update and Restart afterwards - and to ensure UAC is enabled

### HACK Workaround choco / boxstarter path too long error
## https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

$cup = 'choco upgrade --cacheLocation="$ChocoCachePath"'

######################################
#### make sure we're not bothered ####
######################################

Disable-UAC

######################
#### dependencies ####
######################

## NOTE none right now

#########################
#### requires reboot ####
#########################

#######################
#### apps ####
#######################

Invoke-Expression "$cup googlechrome"
Invoke-Expression "$cup 7zip.install"

Invoke-Expression "$cup sysinternals"
## NOTE: by default, installs to C:\tools\sysinternals

Invoke-Expression "$cup windirstat"

Invoke-Expression "$cup lockhunter"
## NOTE: opens webpage after install



Invoke-Expression "$cup microsoft-windows-terminal"
Invoke-Expression "$cup vscode"
Invoke-Expression "$cup windows-admin-center"


#################################
#### NOW get windows updates ####
#################################

Enable-MicrosoftUpdate
Install-WindowsUpdate -AcceptEula

#################
#### cleanup ####
#################

del C:\eula*.txt
del C:\install.*
del C:\vcredist.*
del C:\vc_red.*

###############################
#### windows configuration ####
###############################

## NOTE do these here so that it only happens once (shouldn't reboot any more at this point)

Enable-RemoteDesktop
Set-StartScreenOptions -EnableBootToDesktop -DisableDesktopBackgroundOnStart -DisableShowStartOnActiveScreen -DisableShowAppsViewOnStartScreen
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions
Disable-InternetExplorerESC
Disable-GameBarTips
Disable-BingSearch
Set-TaskbarSmall
New-Item -ItemType Directory "$env:USERPROFILE\Desktop\Master Control.{ED7BA470-8E54-465E-825C-99712043E01C}"
TZUTIL /s "W. Europe Standard Time"



################################
#### restore disabled stuff ####
################################

Enable-UAC

## TODO figure out how to force a single restart here, but only once (not every time the script runs)

#########################
#### manual installs ####
#########################

## NOTE none right now