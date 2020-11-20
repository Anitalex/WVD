$config = Get-Content -Raw -Path .\_config.json | ConvertFrom-Json
$domain = $config.domain

# Connect to Azure
Connect-AzAccount

# Create admin accounts and groups and add admins
$password = Read-Host "What is the password to the brkglss account" | ConvertTo-SecureString -AsPlainText -Force
$user = New-AzADUser -DisplayName 'brkglss' -UserPrincipalName "brkglss@$domain" -Password $password -MailNickname 'brkglss'
$admin = Get-AzADUser -UserPrincipalName "$($config.admin)@$domain"

$aaddsadmins = New-AzADGroup -DisplayName "AAD DC Administrators" -Description "Delegated group to administer Azure AD Domain Services" -MailNickName "AADDCAdministrators"
$aaddsadmins | Add-AzADGroupMember -MemberUserPrincipalName $user.UserPrincipalName
$aaddsadmins | Add-AzADGroupMember -MemberUserPrincipalName $admin.UserPrincipalName

# Register the provider
Register-AzResourceProvider -ProviderNamespace Microsoft.AAD
New-AzADServicePrincipal -ApplicationId "2565bd9d-da50-47d4-8b85-4c97f669dc36"

# Create Resource Groups needed
New-AzResourceGroup -Name $config.resourceGroups.core -Location $config.region
New-AzResourceGroup -Name $config.resourceGroups.wvd -Location $config.region








