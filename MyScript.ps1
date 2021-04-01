##The first computer Credentials##
$userName1 = "Administrator"
$password1 = ConvertTo-SecureString '--------' -AsPlainText -Force
$remoteComputer1 = "3.65.227.85"
##The second computer Credentials##
$userName2 = "Administrator"
$password2 = ConvertTo-SecureString '--------' -AsPlainText -Force
$remoteComputer2 = "18.185.79.201"
Clear-Host
#Can cause some security issues on the host machine! Needed to connect
Set-Item WSMan:localhost\client\trustedhosts -value * -force

#Connecting to the first computer
$cred1 = New-Object System.Management.Automation.PSCredential -ArgumentList ($userName1, $password1)
$session1 = New-PSSession -ComputerName $remoteComputer1 -Credential $cred1
Test-WSMan -ComputerName $remoteComputer1

##installing Internet Information Services (IIS) on the first computer
Invoke-Command -ComputerName $remoteComputer1 -scriptblock {
  Start-Sleep 35
  Install-WindowsFeature -name Web-Server -IncludeManagementTools
} -Credential $cred1

Invoke-Command -ComputerName $remoteComputer1 -scriptblock {
  #deletion of existing website
  $SiteFolderPath = "C:\MySite"
  $SiteAppPool = "MyAppPool"
  $SiteName = "MySite"
  $SiteHostName = "www.MySite.com"
  #deletion of Website, Application Pool and site folder
  Remove-IISSite -Name "MySite" -value * -force
  Remove-WebAppPool $SiteAppPool
  Remove-item "C:\MySite" -Recurse -Force -Confirm:$false
  #creating the new one
  New-Item $SiteFolderPath -type Directory
  Import-Module ServerManager
  Add-WindowsFeature Web-Scripting-Tools
  Import-Module WebAdministration
  New-Item IIS:\AppPools\$SiteAppPool
  New-Item IIS:\Sites\$SiteName -physicalPath $SiteFolderPath -bindings @{protocol="http";bindingInformation=":80:"+$SiteHostName}
  Set-ItemProperty IIS:\Sites\$SiteName -name applicationPool -value $SiteAppPool
  Get-WebBinding
  New-WebBinding -Name 'mysite' -Protocol http -Port 8888
  Get-WebBinding -Name 'mysite'
} -Credential $cred1

##To copy files to the first computer (my index.html file)
 Invoke-Command -ComputerName $remoteComputer1 -scriptblock {
   #Remove-item "C:\MySite\Default.htm" -Recurse -Force -Confirm:$false
   } -Credential $cred1
 $txt = Get-Content -Raw -Path "D:\google drive\GlobalLogic\powershellscript\index.html"
 Invoke-Command -Session $session1 -ScriptBlock { Param($Txt) New-Item -Path "C:\MySite\index.html" -Value $txt -Force }  -ArgumentList $txt
 Disconnect-PSSession $session1 | Out-Null


#Connecting to the second computer
$cred2 = New-Object System.Management.Automation.PSCredential -ArgumentList ($userName2, $password2)
$session2 = New-PSSession -ComputerName $remoteComputer2 -Credential $cred2
Test-WSMan -ComputerName $remoteComputer2

##installing Internet Information Services (IIS) on the first computer
Invoke-Command -ComputerName $remoteComputer2 -scriptblock {
  Start-Sleep 5
  Install-WindowsFeature -name Web-Server -IncludeManagementTools
} -Credential $cred2

Invoke-Command -ComputerName $remoteComputer2 -scriptblock {
  #deletion of existing website
  $SiteFolderPath = "C:\MySite"
  $SiteAppPool = "MyAppPool"
  $SiteName = "MySite"
  $SiteHostName = "www.MySite.com"
  #deletion of Website, Application Pool and site folder
  Remove-IISSite -Name "MySite" -value * -force
  Remove-WebAppPool $SiteAppPool
  Remove-item "C:\MySite" -Recurse -Force -Confirm:$false
  #creating the new one
  New-Item $SiteFolderPath -type Directory
  #Set-Content $SiteFolderPath\Default.htm "<h1>Hello IIS</h1>"
  Import-Module ServerManager
  Add-WindowsFeature Web-Scripting-Tools
  Import-Module WebAdministration
  New-Item IIS:\AppPools\$SiteAppPool
  New-Item IIS:\Sites\$SiteName -physicalPath $SiteFolderPath -bindings @{protocol="http";bindingInformation=":80:"+$SiteHostName}
  Set-ItemProperty IIS:\Sites\$SiteName -name applicationPool -value $SiteAppPool
  Get-WebBinding
  New-WebBinding -Name 'mysite' -Protocol http -Port 8888
  Get-WebBinding -Name 'mysite' } -Credential $cred2

##To copy files to the first computer (my index.html file)
 Invoke-Command -ComputerName $remoteComputer2 -scriptblock {
   #Remove-item "C:\MySite\Default.htm" -Recurse -Force -Confirm:$false
   } -Credential $cred2
 $txt = Get-Content -Raw -Path "D:\google drive\GlobalLogic\powershellscript\index.html"
 Invoke-Command -Session $session2 -ScriptBlock { Param($Txt) New-Item -Path "C:\MySite\index.html" -Value $txt -Force }  -ArgumentList $txt
 Disconnect-PSSession $session2 | Out-Null