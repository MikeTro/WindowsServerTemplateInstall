Install-windowsfeature AD-Domain-Services
Import-Module ADDSDeployment
Import-Module ServerManager
Install-WindowsFeature RSAT-ADDS


$DomainName = "lab.educateit.ch"
$DomainNetbiosName = "lab"
$SafeModeAdministratorPassword = "P@ssword" | ConvertTo-SecureString -AsPlainText -Force
$UserPassword = "Welc0me" | ConvertTo-SecureString -AsPlainText -Force

Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath C:\Windows\NTDS   -DomainMode WinThreshold -DomainName $DomainName -DomainNetbiosName $DomainNetbiosName -ForestMode WinThreshold -InstallDns:$true -LogPath C:\Windows\NTDS -NoRebootOnCompletion:$true -SafeModeAdministratorPassword $SafeModeAdministratorPassword -SysvolPath C:\Windows\SYSVOL -Force:$true


