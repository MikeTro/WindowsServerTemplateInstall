# Domain Join Fix (KB5020276—Netjoin: Domain join hardening changes)
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\ -Name NetJoinLegacyAccountReuse -PropertyType DWORD -Value 1

# config cloudbaseinit
choco install cloudbaseinit -y
Set-Service -Name "cloudbase-init" -StartupType Disabled
Copy-Item -Path "C:\temp\WindowsServerTemplateInstall\Cloudbase-Init\conf\*" -Destination "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\" -force
Copy-Item -Path "C:\temp\WindowsServerTemplateInstall\Cloudbase-Init\LocalScripts\*" -Destination "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\" -force