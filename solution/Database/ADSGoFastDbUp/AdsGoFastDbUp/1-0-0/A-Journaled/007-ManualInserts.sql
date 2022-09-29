UPDATE [dbo].[ExecutionEngine]
SET EngineName = '$DataFactoryName$'
	,SystemType = 'Datafactory'
	,ResourceGroup = '$ResourceGroupName$'
	,SubscriptionUid = '$SubscriptionId$'
	,DefaultKeyVaultURL = 'https://$KeyVaultName$.vault.azure.net/'
	,LogAnalyticsWorkspaceId = '$LogAnalyticsWorkspaceId$'
	,EngineJson = '{}'
WHERE EngineId = '-1'
GO

UPDATE [dbo].[ExecutionEngine]
SET EngineName = '$SynapseWorkspaceName$'
	,SystemType = 'Synapse'
	,ResourceGroup = '$ResourceGroupName$'
	,SubscriptionUid = '$SubscriptionId$'
	,DefaultKeyVaultURL = 'https://$KeyVaultName$.vault.azure.net/'
	,LogAnalyticsWorkspaceId = '$LogAnalyticsWorkspaceId$'
	,EngineJson = '{
            "endpoint": "https://$SynapseWorkspaceName$.dev.azuresynapse.net", "DeltaProcessingNotebook": "DeltaProcessingNotebook", "PurviewAccountName": "$PurviewAccountName$"
        }'
WHERE EngineId = '-2'
GO

UPDATE [dbo].[SourceAndTargetSystems]
SET SystemServer = '$SqlServerName$.database.windows.net'
	,SystemKeyVaultBaseUrl = 'https://$KeyVaultName$.vault.azure.net/'
	,SystemJSON = '{ "Database" : "$SampleDatabaseName$" }'
	,SystemName = '$SqlServerName$\Samples'
WHERE SystemId = '-1'
GO

UPDATE [dbo].[SourceAndTargetSystems]
SET SystemServer = '$SqlServerName$.database.windows.net'
	,SystemKeyVaultBaseUrl = 'https://$KeyVaultName$.vault.azure.net/'
	,SystemJSON = '{ "Database" : "$StagingDatabaseName$" }'
	,SystemName = '$SqlServerName$\Staging'

WHERE SystemId = '-2'
GO

UPDATE [dbo].[SourceAndTargetSystems]
SET SystemServer = '$SqlServerName$.database.windows.net'
	,SystemKeyVaultBaseUrl = 'https://$KeyVaultName$.vault.azure.net/'
	,SystemJSON = '{ "Database" : "$MetadataDatabaseName$" }'
	,SystemName = '$SqlServerName$\Metadata'

WHERE SystemId = '-11'
GO

UPDATE [dbo].[SourceAndTargetSystems]
SET SystemServer = 'https://$BlobStorageName$.blob.core.windows.net'
	,SystemKeyVaultBaseUrl = 'https://$KeyVaultName$.vault.azure.net/'
	,SystemJSON = '{ "Container" : "datalakeraw" }'
	,SystemName = '$BlobStorageName$\datalakeraw'

WHERE SystemId = '-3'
GO

UPDATE [dbo].[SourceAndTargetSystems]
SET SystemServer = 'https://$BlobStorageName$.blob.core.windows.net'
	,SystemKeyVaultBaseUrl = 'https://$KeyVaultName$.vault.azure.net/'
	,SystemJSON = '{ "Container" : "datalakelanding" }'
	,SystemName = '$BlobStorageName$\datalakelanding'

WHERE SystemId = '-7'
GO

UPDATE [dbo].[SourceAndTargetSystems]
SET SystemServer = '$SynapseWorkspaceName$.sql.azuresynapse.net'
	,SystemKeyVaultBaseUrl = 'https://$KeyVaultName$.vault.azure.net/'
	,SystemJSON = '{ "Workspace" : "$SynapseWorkspaceName$", "Database":"$SynapseSQLPoolName$" }'
	,SystemName = '$SynapseWorkspaceName$'

WHERE SystemId = '-10'
GO

UPDATE [dbo].[SourceAndTargetSystems]
SET SystemServer = 'https://$BlobStorageName$.blob.core.windows.net'
	,SystemKeyVaultBaseUrl = 'https://$KeyVaultName$.vault.azure.net/'
	,SystemJSON = '{ "Container" : "transientin" }'
	,SystemName = '$BlobStorageName$\transientin'

WHERE SystemId = '-9'
GO

UPDATE [dbo].[SourceAndTargetSystems]
SET SystemServer = 'https://$AdlsStorageName$.dfs.core.windows.net'
	,SystemKeyVaultBaseUrl = 'https://$KeyVaultName$.vault.azure.net/'
	,SystemJSON = '{ "Container" : "datalakeraw" }'
	,SystemName = '$AdlsStorageName$\datalakeraw'
WHERE SystemId = '-4'
GO

UPDATE [dbo].[SourceAndTargetSystems]
SET SystemServer = 'https://$AdlsStorageName$.dfs.core.windows.net'
	,SystemKeyVaultBaseUrl = 'https://$KeyVaultName$.vault.azure.net/'
	,SystemJSON = '{ "Container" : "datalakelanding" }'
	,SystemName = '$AdlsStorageName$\datalakelanding'
WHERE SystemId = '-8'
GO

UPDATE [dbo].[SourceAndTargetSystems]
SET SystemServer = '(local)'
	,SystemKeyVaultBaseUrl = 'https://$KeyVaultName$.vault.azure.net/'
	,SystemJSON = '{  "Database" : "Adventureworks"  , "PasswordKeyVaultSecretName":"selfhostedsqlpw"   }'
	,SystemAuthType = 'WindowsAuth'
	,SystemUserName = 'adminuser'
	,SystemSecretName = 'selfhostedsqlpw'
	,SystemType = 'SQL Server'
WHERE SystemId = '-14'
GO

UPDATE [dbo].[SourceAndTargetSystems]
SET SystemServer = '(local)'
	,SystemKeyVaultBaseUrl = 'https://$KeyVaultName$.vault.azure.net/'
	,SystemJSON = '{     "PasswordKeyVaultSecretName": "selfhostedsqlpw",     "Username": "adminuser" }'
	,SystemUserName = 'adminuser'
	,SystemSecretName = 'selfhostedsqlpw'
WHERE SystemId = '-15'
GO

