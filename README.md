# windows-powershell

A collection of useful powershell scripts

## DHCP change powershell script

The script is able to change the dns server ip configuration on active network interfaces. The script can set the configuration to dhcp and it can also change the dns server ips to specified ones.

### Examples

#### Resetting to dhcp configuration

Call the script using the specific parameter "dhcpreset" and set it to either 1 or $true

```poweshell
./dns-change.ps1 -dhcpreset 1
or
./dns-change.ps1 -dhcpreset $true
```

#### Changing the dns configuration to the cloudflare IPs

Call the script using no specific parameters

```poweshell
./dns-change.ps1
or
./dns-change.ps1
```

#### Changing the dns configuration to your preferred dns server

Call the script using the dns1 and/or dns2 parameters

```poweshell
./dns-change.ps1 -dns1 "8.8.8.8"
or
./dns-change.ps1 -dns1 "8.8.8.8" -dns2 "8.8.0.0"
```