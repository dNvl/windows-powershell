# This is a script for automatically switching from dhcp to Cloudflare DNS
# Or any other dns server ip given as a function parameter

# The default parameters which can be given to the script as well
param(
    [string] $dns1 = "1.1.1.1",
    [string] $dns2 = "1.0.0.1"
);

# Default error message. Will be overwritten when an action was performed on the network interfaces
[string] $resultDesc = "Error - Nothing has been done.";

function Set-DnsServerForNetworkInterface([System.Object] $interfaceIndex, [string] $dnsSrvIp1, [string] $dnsSrvIp2, [string] $resultMsg) {
    # Get the device name
    $currentDevice = Get-NetAdapter -InterfaceIndex $interfaceIndex;

    # Get the current dns configuration
    $currentDnsServers = Get-DnsClientServerAddress -InterfaceIndex $interfaceIndex -AddressFamily "Ipv4";
    $addresses = [string]::Join(",", $currentDnsServers.ServerAddresses);
    $currentDnsStatus = [string]::format("Current DNS sever ip on device {0} is {1}", $currentDevice.InterfaceDescription, $addresses);
    Write-Output($currentDnsStatus);

    # Check if dhcp is activated
    if ($currentDnsServers.ServerAddresses -eq $dnsSrvIp1 -And $currentDnsServers.ServerAddresses -eq $dnsSrvIp2) {
        # If not change back to dhcp configuration
        Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ResetServerAddresses
        $resultMsg = [string]::format("Switched DNS config on device {0} to DHCP mode.", $currentDevice.InterfaceDescription);
    }
    else {
        # If so, change to static DNS configuration using 1.1.1.1
        Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($dnsSrvIp1, $dnsSrvIp2)

        $resultMsg = [string]::format("Switched DNS config on device {0} to {1} and {2}", $currentDevice.InterfaceDescription, $dnsSrvIp1, $dnsSrvIp2);
    }

    # Return the result text
    return $resultMsg;
}

# Get all the physical network interfaces currently connected and run the function for each of them
$resultMessageAccum = Get-NetAdapter -physical |
    Where-Object status -eq 'up' |
    ForEach-Object { Set-DnsServerForNetworkInterface $_.InterfaceIndex $dns1 $dns2 $resultDesc};

Write-Output($resultMessageAccum);
