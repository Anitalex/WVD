$config = Get-Content -Raw -Path .\_config.json | ConvertFrom-Json

$rg = $config.resourceGroups.core
$name = 'automation'
Import-AzAutomationDscConfiguration -ResourceGroupName $rg –AutomationAccountName $name -SourcePath DSC\AADDSmgmt.ps1 -Published –Force
$jobData = Start-AzAutomationDscCompilationJob -ResourceGroupName $rg –AutomationAccountName $name -ConfigurationName AADDSmgmt
$compilationJobId = $jobData.Id

Get-AzAutomationDscCompilationJob -ResourceGroupName $rg –AutomationAccountName $name -Id $compilationJobId



