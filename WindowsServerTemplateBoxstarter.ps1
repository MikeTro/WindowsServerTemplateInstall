<#
.SYNOPSIS
    Boxstart script for Windows Server Template installation

.DESCRIPTION
    Boxstart script for Windows Server Template installation


.EXAMPLE
    Install-BoxstarterPackage -PackageName WindowsServerTemplateBoxstarter.ps1


.NOTES  
    After a restart/reconnect, even though it shows the login screen, boxstarter is still working


Copyright	: (c)2020 by EducateIT GmbH - http://educateit.ch - info@educateit.ch 
File Name 	: WindowsServerTemplateBoxstarter.ps1
Version		: 1.0
History:
            V1.0 - 18.11.2020 - M.Trojahn - Initial creation  
                
                
#>
#---------------------------------------------------------------------------------------------------------------------------

### HACK Workaround choco / boxstarter path too long error
## https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force
$cup = 'choco upgrade --cacheLocation="$ChocoCachePath"'

#---------------------------------------------------------------------------------------------------------------------------
## make sure we're not bothered 
#---------------------------------------------------------------------------------------------------------------------------

Disable-UAC

#---------------------------------------------------------------------------------------------------------------------------
# dependencies 
#---------------------------------------------------------------------------------------------------------------------------
## NOTE none right now

#---------------------------------------------------------------------------------------------------------------------------
# requires reboot 
#---------------------------------------------------------------------------------------------------------------------------
## NOTE none right now

#---------------------------------------------------------------------------------------------------------------------------
# app installation
#---------------------------------------------------------------------------------------------------------------------------
Invoke-Expression "$cup virtio-drivers"
Invoke-Expression "$cup ultradefrag"
Invoke-Expression "$cup sdelete"
Invoke-Expression "$cup googlechrome"
Invoke-Expression "$cup 7zip.install"
Invoke-Expression "$cup sysinternals"
## NOTE: by default, installs to C:\tools\sysinternals

Invoke-Expression "$cup windirstat"
Invoke-Expression "$cup notepadplusplus.install"


#---------------------------------------------------------------------------------------------------------------------------
# Get windows updates 
#---------------------------------------------------------------------------------------------------------------------------

Enable-MicrosoftUpdate
Install-WindowsUpdate -AcceptEula

#---------------------------------------------------------------------------------------------------------------------------
# cleanup ####
#---------------------------------------------------------------------------------------------------------------------------

del C:\eula*.txt
del C:\install.*
del C:\vcredist.*
del C:\vc_red.*
del $ChocoCachePath
#---------------------------------------------------------------------------------------------------------------------------
# windows configuration ####
#---------------------------------------------------------------------------------------------------------------------------

## NOTE do these here so that it only happens once (shouldn't reboot any more at this point)

Enable-RemoteDesktop
Set-StartScreenOptions -EnableBootToDesktop -DisableDesktopBackgroundOnStart -DisableShowStartOnActiveScreen -DisableShowAppsViewOnStartScreen
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions
Disable-InternetExplorerESC
Disable-GameBarTips
Disable-BingSearch
Set-TaskbarSmall
TZUTIL /s "W. Europe Standard Time"

#---------------------------------------------------------------------------------------------------------------------------
# restore disabled stuff ####
#---------------------------------------------------------------------------------------------------------------------------
Enable-UAC

## TODO figure out how to force a single restart here, but only once (not every time the script runs)




