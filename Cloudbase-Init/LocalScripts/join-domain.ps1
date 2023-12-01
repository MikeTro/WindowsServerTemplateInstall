$scriptDrive = Get-Volume -FileSystemLabel TemplateInstaller
$configFile = $scriptDrive.DriveLetter + ":\DomainConf.xml"


$root = "config"
[xml] $cfg = Get-Content $configFile

$DomainName = $cfg.$root.DomainName
$DomJoinUser = $cfg.$root.DomJoinUser
$DomJoinPassword = $cfg.$root.DomJoinPassword
$DomainController = $cfg.$root.DomainController
$DNSServer = $cfg.$root.DNSServer



try {
	
	# enable rdp
	Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -enabled True
	Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
	Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
	
	
	# CredSSP for ansible
	Enable-WSManCredSSP -Role Server -Force
	
		
	$InterfaceIndex = $(Get-NetAdapter | Select-Object InterfaceIndex).InterfaceIndex
	

	# Join Domain
	$domainJoinCreds = New-Object System.Management.Automation.PSCredential $DomJoinUser,(ConvertTo-SecureString -String $DomJoinPassword -AsPlainText -Force)
	Add-Computer -DomainName $DomainName -Credential $domainJoinCreds -Server $DomainController -Restart:$false -Force
	
	
	Remove-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\ -Name NetJoinLegacyAccountReuse
	exit 1001
}
catch {
    exit 1003
}



