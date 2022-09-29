
<# 
$adsopts = (gci env:* | sort-object name | Where-Object { $_.Name -like "AdsOpts*" })
$obj =  @{}
foreach ($opts in $adsopts) {
    $obj | Add-Member $opts.Name $opts.Value
}

$SubscriptionId = $obj.AdsOpts_CD_ResourceGroup_Id.Split("/")
$obj | Add-Member "AdsOpts_CD_Services_DataFactory_SubscriptionId" $SubscriptionId[2]

$obj | ConvertTo-Json | Set-Content ('./pipeline/static/partials/secrets.libsonnet')
#>

Import-Module ./GatherOutputsFromTerraform_SynapseFolder.psm1 -Force
$tout = GatherOutputsFromTerraform_SynapseFolder
$tout | ConvertTo-Json -Depth 10| Set-Content "./pipeline/static/partials/secrets.libsonnet"