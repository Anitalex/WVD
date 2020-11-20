$config = Get-Content -Raw -Path .\_config.json | ConvertFrom-Json

$AutomationAccount = get-azautomationaccount
$vm = Get-AzVM | where-object {$_.ResourceGroupName -match $config.resourceGroups.core}
$AutomationResourceGroup = $config.resourceGroups.core 
$VMResourceGroup = $config.resourceGroups.core
$NodeConfigurationName = "AADDSmgmt.localhost"
Register-AzAutomationDscNode -AutomationAccountName $AutomationAccount.AutomationAccountName -AzureVMName $VM.Name -ResourceGroupName $AutomationResourceGroup -AzureVMResourceGroup $VMResourceGroup -NodeConfigurationName $NodeConfigurationName



