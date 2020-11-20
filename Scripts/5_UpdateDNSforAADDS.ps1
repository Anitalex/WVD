$config = Get-Content -Raw -Path .\_config.json | ConvertFrom-Json

$VNetResourceGroup = $config.resourceGroups.core
$VNetName = "vnet"

$vnet = get-azvirtualnetwork -ResourceGroupName $VNetResourceGroup -name $VNETName
$array = @("10.1.1.4","10.1.1.5")
$object = new-object -type PSObject -Property @{"DnsServers" = $array}
$vnet.DhcpOptions = $object
$vnet | set-azvirtualnetwork

 