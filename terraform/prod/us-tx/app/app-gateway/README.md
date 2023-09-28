# Application Gateway

Depends on

- Application web servers
- Application Key Vaults
- Go-To-Market Certificate stored in the PROD app-kv with the name:

Concurrent tasks

- Configure DNS to point to the AGW

## Creating an initial place holder certificate

```powershell
New-SelfSignedCertificate -DnsName 'appgateway.azurelaunchpad.com' -certstorelocation cert:\localmachine\my

$pwd = ConvertTo-SecureString -String Pass -Force -AsPlainText

Export-PfxCertificate -Cert cert:\localMachine\my\468292E97A98DC9DBB2FF526511FD3C3F78FD6BA -FilePath 'C:\Users\dfrancis\OneDrive - Coalfire\Desktop\appgwcert.pfx' -Password $pwd 
```

## Overview

The App Gateway is deployed with OWASP rules in prevention mode.

There is a user defined managed ID created and assigned to the Application Gateway, that ID has access to the application key vault to pull the SSL certificate used by the App gateway.

## Outputs

| Name | Description |
|------|-------------|
| ussc_app_gateway_ip_id | ID of the public IP of the gateway |
