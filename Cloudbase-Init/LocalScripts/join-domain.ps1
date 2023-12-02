

function Write-Log 
{
	param (
		[Parameter(Mandatory=$True)] [string]$LogFile,
		[Parameter(Mandatory=$True)] [string]$LogString
	)
	$Stamp = (Get-Date).toString("yyyy.mm.dd HH:mm:ss")
	$LogMessage = "$Stamp $LogString"
	Add-Content $LogFile -Value $LogMessage
}	

$logFile = "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\join-domain.log"
	
try {
	Write-Log -LogFile $LogFile -LogString "Get ConfigDrive..."
	$scriptDrive = Get-Volume -FileSystemLabel TemplateInstaller
	$configFile = $scriptDrive.DriveLetter + ":\DomainConf.xml"
	

	Write-Log -LogFile $LogFile -LogString "Read config..."

	$root = "config"
	[xml] $cfg = Get-Content $configFile

	$DomainName = $cfg.$root.DomainName
	$DomJoinUser = $cfg.$root.DomJoinUser
	$DomJoinPassword = $cfg.$root.DomJoinPassword
	$DomainController = $cfg.$root.DomainController
	$DNSServer = $cfg.$root.DNSServer


	
	Write-Log -LogFile $LogFile -LogString "DomainName: $DomainName"
	Write-Log -LogFile $LogFile -LogString "DomJoinUser: $DomJoinUser"
	Write-Log -LogFile $LogFile -LogString "DomainController: $DomainController"
	Write-Log -LogFile $LogFile -LogString "DNSServer: $DNSServer"
	
	Write-Log -LogFile $LogFile -LogString "enable winrm"
	winrm quickconfig -quiet
	
	# enable rdp
	Write-Log -LogFile $LogFile -LogString "enable rdp"
	Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -enabled True
	Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
	Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
	
	
	# CredSSP for ansible
	Write-Log -LogFile $LogFile -LogString "CredSSP for ansible"
	Enable-WSManCredSSP -Role Server -Force
	
		
	$InterfaceIndex = $(Get-NetAdapter | Select-Object InterfaceIndex).InterfaceIndex
	

	# Join Domain
	Write-Log -LogFile $LogFile -LogString "Join Domain"
	$domainJoinCreds = New-Object System.Management.Automation.PSCredential $DomJoinUser,(ConvertTo-SecureString -String $DomJoinPassword -AsPlainText -Force)
	Add-Computer -DomainName $DomainName -Credential $domainJoinCreds -Server $DomainController -Restart:$false -Force
	Remove-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\ -Name NetJoinLegacyAccountReuse
	Write-Log -LogFile $LogFile -LogString "Exit 1001"
	exit 1001
}
catch {
	<# Write-Host $_.Exception.Message #>
	Write-Log -LogFile $LogFile -LogString "$_.Exception.Message"
	Write-Log -LogFile $LogFile -LogString "Exit 1003"
    exit 1003
}



