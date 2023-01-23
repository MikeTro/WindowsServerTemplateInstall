Get-PackageProvider -name nuget -force
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install git.install -y
choco install Boxstarter -y

mkdir c:/temp
cd c:/temp
& "C:\Program Files\Git\bin\git.exe" clone https://github.com/MikeTro/WindowsServerTemplateInstall.git








