<#
To execute this script, you first need the permissions to run scripts on this machine. Run a powershell as administrator and execute:
Get-ExecutionPolicy
-> RemoteSigned is fine, but you cannot run .ps1 scripts in Restricted mode (default for windows home).  
Run:
Set-ExecutionPolicy RemoteSigned
#>

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments 
  Break  
}

$distro = "cluster"
$vmIP = wsl -d $distro bash -c "ifconfig eth0 | grep 'inet ' | awk '{print \`$2`}'"
echo "# Forwarding from WSL distro: $distro with IP: $vmIP"
echo "----------------------------------------------------"
if( !$vmIP ){
  echo "Ip address of the distro $distro not found. Exiting...";
  exit;
}
$internalPorts = wsl -d $distro -u ops bash -c "kubectl get svc -A -o yaml | grep nodePort |  awk '{print \`$3`}'| head -c -1 | tr '\n' ','"
$portsArray = $internalPorts.split(",")
$hostPortStart = 17000
netsh interface portproxy reset
$i=0
foreach ($port in $portsArray) {
  $listenPort = $hostPortStart + $i++
  echo "forwarding port $port -> 0.0.0.0:$listenPort"
  netsh interface portproxy add v4tov4 listenport=$listenPort listenaddress=0.0.0.0 connectport=$port connectaddress=$vmIP
}
netsh interface portproxy show v4tov4
Start-Sleep -s 10