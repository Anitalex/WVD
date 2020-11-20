$config = Get-Content -Raw -Path .\_config.json | ConvertFrom-Json
$admin = $config.admin
$adminacct = Get-AzADUser -UserPrincipalName "$admin@wilsonllp.com"
$domain = $config.domain

function Format-Json([Parameter(Mandatory, ValueFromPipeline)][String] $json) {
    $indent = 0;
    ($json -Split "`n" | % {
        if ($_ -match '[\}\]]\s*,?\s*$') {
            # This line ends with ] or }, decrement the indentation level
            $indent--
        }
        $line = ('  ' * $indent) + $($_.TrimStart() -replace '":  (["{[])', '": $1' -replace ':  ', ': ')
        if ($_ -match '[\{\[]\s*$') {
            # This line ends with [ or {, increment the indentation level
            $indent++
        }
        $line
    }) -Join "`n"
}

# setting up AADDS
$aadds = Get-Content -Path .\Templates\aadds.parameters.json | ConvertFrom-Json
$aadds.parameters.domainname.value = $config.domain
$aadds.parameters.location.value = $config.region
$aadds  | ConvertTo-Json | Format-Json | Set-Content -Path .\Templates\aadds.parameters.json
New-AzResourceGroupDeployment -Name 'AADDS' -ResourceGroupName $config.resourceGroups.core  -TemplateParameterFile .\Templates\aadds.parameters.json -TemplateFile .\Templates\aadds.json -Verbose

# Create key vault
$keyvault = Get-Content -Path .\Templates\keyvault.parameters.json | ConvertFrom-Json
$keyvault.parameters.keyVaultName.value = "kv-01-$(($domain).split(".")[0])"
$keyvault.parameters.objectId.value = $adminacct.Id
$keyvault.parameters.secretName.value = $config.secret.name
$keyvault  | ConvertTo-Json | Format-Json | Set-Content -Path .\Templates\keyvault.parameters.json
New-AzResourceGroupDeployment -Name 'KeyVault' -ResourceGroupName $config.resourceGroups.core  -TemplateParameterFile .\Templates\keyvault.parameters.json -TemplateFile .\Templates\keyvault.json -Verbose

# Create automation account
New-AzResourceGroupDeployment -Name 'Automation' -ResourceGroupName $config.resourceGroups.core -TemplateFile .\Templates\automation.json -Verbose


