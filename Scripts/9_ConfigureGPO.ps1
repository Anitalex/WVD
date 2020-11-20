$domain = $env:USERDNSDOMAIN
$policydef = "\\$domain\SYSVOL\$domain\Policies\"

if (Test-Path "$policydef\PolicyDefinitions"){
} else {
    New-Item -Path $policydef -Name "PolicyDefinitions" -ItemType Directory
    New-Item -Path "$policydef\PolicyDefinitions" -Name "en-US" -ItemType Directory
}

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Accept", "application/vnd.github.VERSION.raw")

$onedriveADMLurl = "https://github.com/Anitalex/poshscripts/tree/main/admx/OneDrive.adml"
$onedriveADMXurl = "https://github.com/Anitalex/poshscripts/tree/main/admx/OneDrive.admx"
$fslogixADMLurl = "https://github.com/Anitalex/poshscripts/tree/main/admx/fslogix.adml"
$fslogixADMXurl = "https://github.com/Anitalex/poshscripts/tree/main/admx/fslogix.admx"
$fslogixRedirectURL = "https://github.com/Anitalex/poshscripts/tree/main/fslogix/Redirections.xml"

Invoke-RestMethod  $onedriveADMLurl -OutFile "$policydef\PolicyDefinitions\en-US\OneDrive.adml" -Method 'GET' -Headers $headers | ConvertTo-Json
Invoke-RestMethod  $onedriveADMXurl -OutFile "$policydef\PolicyDefinitions\OneDrive.admx" -Method 'GET' -Headers $headers | ConvertTo-Json
Invoke-RestMethod  $fslogixADMLurl -OutFile "$policydef\PolicyDefinitions\en-US\fslogix.adml" -Method 'GET' -Headers $headers | ConvertTo-Json
Invoke-RestMethod  $fslogixADMXurl -OutFile "$policydef\PolicyDefinitions\fslogix.admx" -Method 'GET' -Headers $headers | ConvertTo-Json





Copy-Item "C:\Windows\PolicyDefinitions\*" -Destination "$policydef\PolicyDefinitions" -Recurse



$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($onedriveADMLurl ,"$policydef\PolicyDefinitions\en-US\OneDrive.adml")

$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($onedriveADMXurl ,"$policydef\PolicyDefinitions\OneDrive.admx")

$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($fslogixADMLurl ,"$policydef\PolicyDefinitions\en-US\fslogix.adml")

$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($fslogixADMXurl ,"$policydef\PolicyDefinitions\fslogix.admx")






