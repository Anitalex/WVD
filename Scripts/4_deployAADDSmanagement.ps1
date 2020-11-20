$config = Get-Content -Raw -Path .\_config.json | ConvertFrom-Json
$domain = ($config.domain).split(".")[0]

$vault = Get-AzKeyVault
$id =  $vault.resourceid

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

# deploy AADDS management VM
$keyvault = Get-Content -Path .\Templates\aadds-mgmt.parameters.json | ConvertFrom-Json
$keyvault.parameters.adminUsername.value = $config.secret.name
$keyvault.parameters.adminPassword.reference.secretName = $config.secret.name
$keyvault.parameters.adminPassword.reference.keyvault.id = $id
$keyvault.parameters.dnsLabelPrefix.value  = "aadds-mgmt-$domain"
$keyvault | ConvertTo-Json -Depth 6 | Format-Json | Set-Content -Path .\Templates\aadds-mgmt.parameters.json
New-AzResourceGroupDeployment -Name 'aadds-mgmt' -ResourceGroupName $config.resourceGroups.core  -TemplateParameterFile .\Templates\aadds-mgmt.parameters.json -TemplateFile .\Templates\aadds-mgmt.json -Verbose

