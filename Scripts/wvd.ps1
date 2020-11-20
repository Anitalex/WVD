$config = Get-Content -Raw -Path .\_config.json | ConvertFrom-Json

$resprov = Get-AzResourceProvider -ProviderNamespace Microsoft.DesktopVirtualization
if(!$resprov){
    Register-AzResourceProvider -ProviderNamespace Microsoft.DesktopVirtualization
}


New-AzWvdHostPool -ResourceGroupName $config.resourceGroups.wvd -Name $config.wvd.hostpoolname -WorkspaceName $config.wvd.hostpoolname -HostPoolType $config.wvd.hostpooltype -LoadBalancerType $config.wvd.LoadBalancerType -Location $config.region -DesktopAppGroupName $config.wvd.hostpoolname



