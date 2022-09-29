function()
{
    local tout = import "../output/tout.json",
	"name": "SLS_AzureFunctionApp",
	"type": "Microsoft.DataFactory/factories/linkedservices",
	"properties": {
		"type": "AzureFunction",
		"typeProperties": {
			"functionAppUrl": tout.functionapp_url,
			"functionKey": {
				"secretName": "AdsGfCoreFunctionAppKey",
				"store": {
					"referenceName": "SLS_AzureKeyVault",
					"type": "LinkedServiceReference"
				},
				"type": "AzureKeyVaultSecret"
			}
		},
		"annotations": []
	}
}