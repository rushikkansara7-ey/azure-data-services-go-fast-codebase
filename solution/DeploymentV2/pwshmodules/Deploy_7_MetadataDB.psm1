function DeployMataDataDB (
    [Parameter(Mandatory = $false)]
    [bool]$publish_metadata_database = $false, 
    [Parameter(Mandatory = $true)]
    [pscustomobject]$tout = $false,
    [Parameter(Mandatory = $true)]
    [string]$deploymentFolderPath = "",
    [Parameter(Mandatory = $true)]
    [String]$PathToReturnTo = ""
)
{
    #----------------------------------------------------------------------------------------------------------------
    #   Populate the Metadata Database
    #----------------------------------------------------------------------------------------------------------------
    if ($publish_metadata_database -eq $false) {
        Write-Host "Skipping Populating Metadata Database"    
    }
    else {
    
        Write-Host "Populating Metadata Database"

        Set-Location $deploymentFolderPath
        Set-Location "..\Database\ADSGoFastDbUp\AdsGoFastDbUp"
        dotnet restore
        dotnet publish --no-restore --configuration Release --output '..\..\..\DeploymentV2\bin\publish\unzipped\database\'
    
        #Add Ip to SQL Firewall
        $result = az sql server update -n $tout.sqlserver_name -g $tout.resource_group_name  --set publicNetworkAccess="Enabled" --only-show-errors

        $myIp = $env:TF_VAR_ip_address
        $myIp2 = $env:TF_VAR_ip_address2

        if ($myIp -ne $null) {
            $result = az sql server firewall-rule create -g $tout.resource_group_name -s $tout.sqlserver_name -n "CICDAgent" --start-ip-address $myIp --end-ip-address $myIp --only-show-errors
        }
        if ($myIp2 -ne $null) {        
            $result = az sql server firewall-rule create -g $tout.resource_group_name -s $tout.sqlserver_name -n "CICDUser" --start-ip-address $myIp2 --end-ip-address $myIp2 --only-show-errors
        }
        #Allow Azure services and resources to access this server
        $result = az sql server firewall-rule create -g $tout.resource_group_name -s $tout.sqlserver_name -n "Azure" --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0 --only-show-errors

        Set-Location $deploymentFolderPath
        Set-Location ".\bin\publish\unzipped\database\"

        $lake_database_container_name = $tout.synapse_lakedatabase_container_name

        # This has been updated to use the Azure CLI cred
        dotnet AdsGoFastDbUp.dll -a True -c "Data Source=tcp:$($tout.sqlserver_name).database.windows.net;Initial Catalog=$($tout.metadatadb_name);" -v True --DataFactoryName $tout.datafactory_name --ResourceGroupName $tout.resource_group_name --KeyVaultName $tout.keyvault_name --LogAnalyticsWorkspaceId $tout.loganalyticsworkspace_id --SubscriptionId $tout.subscription_id --SampleDatabaseName $tout.sampledb_name --StagingDatabaseName $tout.stagingdb_name --MetadataDatabaseName $tout.metadatadb_name --BlobStorageName $tout.blobstorage_name --AdlsStorageName $tout.adlsstorage_name --WebAppName $tout.webapp_name --FunctionAppName $tout.functionapp_name --SqlServerName $tout.sqlserver_name --SynapseWorkspaceName $tout.synapse_workspace_name --SynapseDatabaseName $tout.synapse_sql_pool_name --SynapseSQLPoolName $tout.synapse_sql_pool_name --SynapseSparkPoolName $tout.synapse_spark_pool_name --PurviewAccountName $tout.purview_name --SynapseLakeDatabaseContainerName $tout.synapse_lakedatabase_container_name
    
        <# # Fix the MSI registrations on the other databases. I'd like a better way of doing this in the future
        $SqlInstalled = false
        try { 
            $SqlInstalled = Get-InstalledModule SqlServer
        }
        catch { "SqlServer PowerShell module not installed." }
    
        if ($null -eq $SqlInstalled) {
            write-host "Installing SqlServer Module"
            Install-Module -Name SqlServer -Scope CurrentUser -Force
        } #>
            
        Set-Location $deploymentFolderPath

        if([string]::IsNullOrEmpty($PathToReturnTo) -ne $true)
        {
            Write-Debug "Returning to $PathToReturnTo"
            Set-Location $PathToReturnTo
        }
        else {
            Write-Debug "Path to return to is null"
        }
    }
}