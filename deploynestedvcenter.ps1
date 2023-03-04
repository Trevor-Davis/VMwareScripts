
# Author: Trevor Davis
# Note: This script is a modified version of what William Lam (www.williamlam.com wrote), used that as the base for this script.
# Website: www.virtualworkloads.com
# Twitter: vTrevorDavis
# This script can be used to install a nested vCenter Server

$hostvcenter = "10.0.0.2" # vCenter Server Which Will Host the Nested Environment
$hostvcenterusername = "cloudadmin@vsphere.local" # vCenter Server Which Will Host the Nested Environment
$hostvcenterpassword = "0M7$*zt9a3iH" # vCenter Server Which Will Host the Nested Environment
$pathtovcenterinstaller = "f:\" #typically you will have an ISO file for vCenter, mount that and put the drive letter here.
$network = "NestedLab" #the network to deploy the vCenter server
$datastore = "vsanDatastore" #the datastore where vCenter will be deployed
$datacenter = "SDDC-Datacenter" #the name of the datacenter where this vCenter VM will be deployed
$cluster = "Cluster-1" #The cluster where the nested vCenter will be deployed
$nestedvcenterdeploymentsize = "tiny" 
$nestedvcentername = "vcenter2"
$nestedvcenterip = "192.168.89.77"
$nestedvcenterprefix = "24"
$nestedvcentergateway = "192.168.89.1"
$nestedvcenterntpserver = "time.nist.gov"
$nestedvcenterdnsserver = "10.20.0.4"
$nestedvcenterrootpassword = "Microsoft1!"
$nestedvcentersso = "vsphere.local" #HIGHLY RECOMMENDED to not change this
$nestedvcenterpassword = "Microsoft1!"


$config = (Get-Content -Raw "$($pathtovcenterinstaller)\vcsa-cli-installer\templates\install\embedded_vCSA_on_VC.json") | convertfrom-json

    $config.'new_vcsa'.vc.hostname = $hostvcenter
    $config.'new_vcsa'.vc.username = $hostvcenterusername
    $config.'new_vcsa'.vc.password = $hostvcenterpassword
    $config.'new_vcsa'.vc.deployment_network = $network
    $config.'new_vcsa'.vc.datastore = $datastore
    $config.'new_vcsa'.vc.target = $cluster
    $config.'new_vcsa'.vc.datacenter = $datacenter
    $config.'new_vcsa'.appliance.thin_disk_mode = $true
    $config.'new_vcsa'.appliance.deployment_option = $nestedvcenterdeploymentsize
    $config.'new_vcsa'.appliance.name = $nestedvcentername
    $config.'new_vcsa'.network.ip_family = "ipv4"
    $config.'new_vcsa'.network.mode = "static"
    $config.'new_vcsa'.network.ip = $nestedvcenterip
    $config.'new_vcsa'.network.dns_servers[0] = $nestedvcenterdnsserver
    $config.'new_vcsa'.network.prefix = $nestedvcenterprefix
    $config.'new_vcsa'.network.gateway = $nestedvcentergateway
    $config.'new_vcsa'.os.ntp_servers = $nestedvcenterntpserver
    $config.'new_vcsa'.network.system_name = $nestedvcenterip
    $config.'new_vcsa'.os.password = $nestedvcenterrootpassword
    $config.'new_vcsa'.os.ssh_enable = $true
    $config.'new_vcsa'.sso.password = $nestedvcenterpassword
    $config.'new_vcsa'.sso.domain_name = $nestedvcentersso
    $config.ceip.settings.ceip_enabled = $false
    $config | ConvertTo-Json | Set-Content -Path "$($ENV:Temp)\jsontemplate.json"
    

    Invoke-Expression "$($pathtovcenterinstaller)\vcsa-cli-installer\win32\vcsa-deploy.exe install --no-ssl-certificate-verification --accept-eula --acknowledge-ceip $($ENV:Temp)\jsontemplate.json"

    Start-Process "https://$($nestedvcenterip)"     