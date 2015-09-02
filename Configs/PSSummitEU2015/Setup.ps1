﻿$cred = Get-Credential

#Prep Pull Server
    Write-Host "Starting configuration of Pull Server."
    #Copy and install private SSL certificate
    dir .\fabricam_ssl.pfx | Copy-VMFile -Name Pull -DestinationPath 'c:\temp\fabricam_ssl.pfx' -CreateFullPath -FileSource Host -Force
    #Use PowerShell direct to run a script on a VM.
    Invoke-Command -VMName Pull -ScriptBlock {$Password = Read-Host -Prompt 'Enter Password for SSL Certificate:' -AsSecureString;Import-PfxCertificate -Password $Password -CertStoreLocation 'Cert:\LocalMachine\My' -FilePath 'c:\temp\fabricam_ssl.pfx'} -Credential $cred
    Invoke-Command -VMName Pull -ScriptBlock {del 'c:\temp' -Recurse} -Credential $cred
    Write-Host "   Completed: copied and installed SSL Certificate"

    #Set IP Address
    Invoke-Command -VMName Pull -ScriptBlock {New-NetIPAddress -IPAddress '10.0.0.10' -InterfaceAlias 'Ethernet' -AddressFamily IPv4} -Credential $cred
    Write-Host "   Completed: set Host IP Address"

    #Disable firewall
    Invoke-Command -VMName Pull -ScriptBlock {Set-NetFirewallProfile -Name Public -Enabled False;Set-NetFirewallProfile -Name Domain -Enabled False;Set-NetFirewallProfile -Name Private -Enabled False} -Credential $cred
    Write-Host "   Completed: disabled firewall"

    #Add DNS name to host file
    Invoke-Command -VMName Pull -ScriptBlock {"`r`n10.0.0.10`tcorp.fabricam.com" | Out-File -FilePath 'c:\windows\system32\drivers\etc\hosts' -Encoding ascii -Append} -Credential $cred
    Write-Host "   Completed: set hosts file"

    #Add Demo user
    Invoke-Command -VMName Pull -ScriptBlock {$CN = [ADSI]"WinNT://$env:computername";$user = $CN.Create("User","Demo");$user.SetPassword("Sd2-mmtp");$user.UserFlags = 64 + 65536;$user.SetInfo();$Admins = [ADSI]"WinNT://$env:computername/Administrators,group";$Admins.Add("WinNT://$env:computername/Demo,user");} -Credential $cred
    Write-Host "   Completed: created Demo user"
    Write-Host "Completed: Pull server setup"

#Prep Target Node
    Write-Host ""
    Write-Host "Starting configuration of Pull Server."
    #Copy public SSL certificate
    dir .\fabricam_ssl.cer | Copy-VMFile -Name Server -DestinationPath 'c:\temp\fabricam_ssl.cer' -CreateFullPath -FileSource Host -Force
    Invoke-Command -VMName Server -ScriptBlock {Import-Certificate -FilePath 'c:\temp\fabricam_ssl.cer' -CertStoreLocation Cert:\LocalMachine\Root} -Credential $cred
    Write-Host "   Completed: copied and installed SSL Certificate"

    #Set IP Address
    Invoke-Command -VMName Server -ScriptBlock {New-NetIPAddress -IPAddress '10.0.0.11' -InterfaceAlias 'Ethernet' -AddressFamily IPv4} -Credential $cred
    Write-Host "   Completed: set Host IP Address"

    #Disable Firewall
    Invoke-Command -VMName Server -ScriptBlock {Set-NetFirewallProfile -Name Public -Enabled False;Set-NetFirewallProfile -Name Domain -Enabled False;Set-NetFirewallProfile -Name Private -Enabled False} -Credential $cred
    Write-Host "   Completed: disabled firewall"

    #Add DNS name to host file
    Invoke-Command -VMName Server -ScriptBlock {"`r`n10.0.0.10`tcorp.fabricam.com" | Out-File -FilePath 'c:\windows\system32\drivers\etc\hosts' -Encoding ascii -Append} -Credential $cred
    Write-Host "   Completed: set hosts file"

    #Add Demo user
    Invoke-Command -VMName Server -ScriptBlock {$CN = [ADSI]"WinNT://$env:computername";$user = $CN.Create("User","Demo");$user.SetPassword("Sd2-mmtp");$user.UserFlags = 64 + 65536;$user.SetInfo();$Admins = [ADSI]"WinNT://$env:computername/Administrators,group";$Admins.Add("WinNT://$env:computername/Demo,user");} -Credential $cred
    Write-Host "   Completed: created Demo user"
    Write-Host "Completed: Pull server setup"

    <#
    $SSLCertFilePath = 'C:\Configs\fabricam_ssl.pfx'
    $SSLThumbprint = (Get-PfxCertificate -FilePath $SSLCertFilePath).Thumbprint
    $SSLCert = dir "Cert:\LocalMachine\My\$SSLThumbprint"

    #"`r`n10.0.0.10`tcorp.fabricam.com" | Out-File -FilePath 'c:\windows\system32\drivers\etc\hosts' -Encoding ascii -Append

    if(!$SSLCert)
    {
        $SSLCertPassword = Read-Host -Prompt 'Enter Password for SSL Certificate:' -AsSecureString

        #Import SSL cert for use by website
        Import-PfxCertificate -FilePath $SSLCertFilePath -CertStoreLocation 'cert:\LocalMachine\My' -Password $SSLCertPassword

        #Import SSL cert into trusted root
        Import-PfxCertificate -FilePath $SSLCertFilePath -CertStoreLocation 'cert:\LocalMachine\root' -Password $SSLCertPassword
    }
    #>