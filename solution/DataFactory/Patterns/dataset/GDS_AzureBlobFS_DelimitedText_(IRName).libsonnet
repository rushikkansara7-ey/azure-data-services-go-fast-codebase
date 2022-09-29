function(shortIRName = "", fullIRName = "")
{
	"name": "GDS_AzureBlobFS_DelimitedText_" + shortIRName,
	"properties": {
		"linkedServiceName": {
			"referenceName": "GLS_AzureBlobFS_" + shortIRName,
			"type": "LinkedServiceReference",
			"parameters": {
				"StorageAccountEndpoint": {
					"value": "@dataset().StorageAccountEndpoint",
					"type": "Expression"
				}
			}
		},
		"parameters": {
			"RelativePath": {
				"type": "string"
			},
			"FileName": {
				"type": "string"
			},
			"StorageAccountEndpoint": {
				"type": "string"
			},
			"StorageAccountContainerName": {
				"type": "string"
			},
			"FirstRowAsHeader": {
				"type": "bool"
			}
		},
		"folder": {
			"name": "ADS Go Fast/Generic/" + fullIRName
		},
		"annotations": [],
		"type": "DelimitedText",
		"typeProperties": {
			"location": {
				"type": "AzureBlobFSLocation",
				"fileName": {
					"value": "@dataset().FileName",
					"type": "Expression"
				},
				"folderPath": {
					"value": "@dataset().RelativePath",
					"type": "Expression"
				},
				"fileSystem": {
					"value": "@dataset().StorageAccountContainerName",
					"type": "Expression"
				}
			},
			"columnDelimiter": ",",
			"escapeChar": "\\",
			"firstRowAsHeader": {
				"value": "@dataset().FirstRowAsHeader",
				"type": "Expression"
			},
			"quoteChar": "\""
		},
		"schema": []
	},
	"type": "Microsoft.DataFactory/factories/datasets"
}

