if ($avsdeploy_ps1 -ne "Yes") {
    Add-Type -AssemblyName Microsoft.VisualBasic
    $inputbox = "What is the IP address of the vCenter Server?"
    $OnPremVIServerIP = [Microsoft.VisualBasic.Interaction]::InputBox($inputbox)

}

if ($avsdeploy_ps1 -eq "Yes") {
    Add-Type -AssemblyName Microsoft.VisualBasic
    $inputbox = "You will now be prompted to provide the credentials for the ON-PREMISES vCenter Server $OnPremVIServerIP where HCX will be deployed 
    
Press OK to Continue"

[Microsoft.VisualBasic.Interaction]::MsgBox($inputbox)

}

Add-Type -AssemblyName Microsoft.VisualBasic
$inputbox = "What is the USERNAME of the vCenter Server $OnPremVIServerIP"
$VIServerUsername = [Microsoft.VisualBasic.Interaction]::InputBox($inputbox, ' ')

Add-Type -AssemblyName Microsoft.VisualBasic
$inputbox = "What is the PASSWORD of the vCenter Server $OnPremVIServerIP"
$VIServerPassword = [Microsoft.VisualBasic.Interaction]::InputBox($inputbox, ' ')

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Connect-VIServer -Server $VIServerIP -username $VIServerUsername -password $VIServerPassword