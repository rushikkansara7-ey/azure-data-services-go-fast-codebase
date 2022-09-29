function(shortIRName = "", fullIRName = "") 
{
	"name": "GLS_SqlServerDatabase_sqlauth_" + shortIRName,
	"type": "Microsoft.DataFactory/factories/linkedservices",
	"properties": {
		"connectVia": {
			"referenceName": fullIRName,
			"type": "IntegrationRuntimeReference"
		},
		"description": "Generic SqlServer",
		"parameters": {
			"Database": {
				"type": "String",
				"defaultValue": ""
			},
			"KeyVaultBaseUrl": {
				"type": "String",
				"defaultValue": ""
			},
			"PasswordSecret": {
				"type": "String",
				"defaultValue": ""
			},
			"Server": {
				"type": "String",
				"defaultValue": ""
			},
			"UserName": {
				"type": "String",
				"defaultValue": ""
			}
		},
		"type": "SqlServer",
		"typeProperties": {
			"connectionString": "Integrated Security=False;Data Source=@{linkedService().Server};Initial Catalog=@{linkedService().Database};User ID=@{linkedService().UserName}",
			"password": {
				"secretName": {
					"type": "Expression",
					"value": "@linkedService().PasswordSecret"
				},
				"store": {
					"parameters": {
						"KeyVaultBaseUrl": {
							"type": "Expression",
							"value": "@linkedService().KeyVaultBaseUrl"
						}
					},
					"referenceName": "GLS_AzureKeyVault_" + shortIRName,
					"type": "LinkedServiceReference"
				},
				"type": "AzureKeyVaultSecret"
			}
		},
		"annotations": []
	}
}