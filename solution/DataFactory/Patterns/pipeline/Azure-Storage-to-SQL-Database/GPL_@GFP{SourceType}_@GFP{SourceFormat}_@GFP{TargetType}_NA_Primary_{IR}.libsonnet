function(GenerateArm="true",GFPIR="IRA", SourceType="AzureBlobFS", SourceFormat="Parquet", TargetType="AzureSqlTable",TargetFormat="Table")
	local generateArmAsBool = GenerateArm == "true";
	local Wrapper = import '../static/partials/wrapper.libsonnet';

	local typeProperties = import './partials/MainCopyActivity/typeProperties/typeProperties.libsonnet';
	local dataset_inputs = {
		"DelimitedText" : import './partials/MainCopyActivity/datasetReferences/DelimitedText.libsonnet',
		"Excel" : import './partials/MainCopyActivity/datasetReferences/Excel.libsonnet',
		"Json" : import './partials/MainCopyActivity/datasetReferences/Json.libsonnet',
		"Parquet" : import './partials/MainCopyActivity/datasetReferences/Parquet.libsonnet'
	};

	local dataset_outputs = {
		"AzureSqlTable" : import './partials/MainCopyActivity/datasetReferences/AzureSqlTable.libsonnet',
		"AzureSqlDWTable" : import './partials/MainCopyActivity/datasetReferences/AzureSqlDWTable.libsonnet'		
	};

	local Main_CopyActivity_TypeProperties = import './partials/Main_CopyActivity_TypeProperties.libsonnet';
	local name =  if(!generateArmAsBool) 
			then "GPL_"+SourceType+"_"+SourceFormat+"_"+TargetType+"_"+"NA"+"_" + "Primary_" + GFPIR 
			else "[concat(parameters('dataFactoryName'), '/','GPL_"+SourceType+"_"+SourceFormat+"_"+TargetType+"_"+"NA_Primary_" + "', parameters('integrationRuntimeShortName'))]";
	local pipeline = 
	{
		"name":name,
		"properties": {
			"activities": [
				{
					"name": "Pipeline AF Log - ADLS to Azure SQL Start",
					"type": "ExecutePipeline",
					"dependsOn": [],
					"userProperties": [],
					"typeProperties": {
						"pipeline": {
							"referenceName": "SPL_AzureFunction",
							"type": "PipelineReference"
						},
						"waitOnCompletion": false,
						"parameters": {
							"Body": {
								"value": "@json(concat('{\"TaskInstanceId\":\"', string(pipeline().parameters.TaskObject.TaskInstanceId), '\",\"ExecutionUid\":\"', string(pipeline().parameters.TaskObject.ExecutionUid), '\",\"RunId\":\"', string(pipeline().RunId), '\",\"LogTypeId\":3,\"LogSource\":\"ADF\",\"ActivityType\":\"Copy to SQL\",\"StartDateTimeOffSet\":\"', string(pipeline().TriggerTime), '\",\"Status\":\"Started\"}'))",
								"type": "Expression"
							},
							"FunctionName": "Log",
							"Method": "Post"
						}
					}
				},
				{
					"name": "If Auto Create Table",
					"description": "Auto Creates Table Using a Schema File",
					"type": "IfCondition",
					"dependsOn": [
						{
							"activity": "Pipeline AF Log - ADLS to Azure SQL Start",
							"dependencyConditions": [
								"Succeeded"
							]
						}],
					"userProperties": [],
					"typeProperties": {
						"expression": {
							"value": "@and(not(equals(coalesce(pipeline().parameters.TaskObject.Source.SchemaFileName,''),'')),bool(pipeline().parameters.TaskObject.Target.AutoCreateTable))",
							"type": "Expression"
						},
						"ifTrueActivities": [
							{
								"name": "Execute Create Table",
								"type": "ExecutePipeline",
								"dependsOn": [],
								"userProperties": [],
								"typeProperties": {
									"pipeline": {
										"referenceName":if(GenerateArm=="false") 
														then "GPL_"+TargetType+"_"+"NA"+"_Create_Table_"+GFPIR 
														else "[concat('GPL_"+TargetType+"_"+"NA"+"_Create_Table_" + "', parameters('integrationRuntimeShortName'))]",
										"type": "PipelineReference"
									},
									"waitOnCompletion": true,
									"parameters": {
										"TaskObject": {
											"value": "@pipeline().parameters.TaskObject",
											"type": "Expression"
										}
									}
								}
							},
							{
								"name": "AF Get Mapping",
								"type": "AzureFunctionActivity",
								"dependsOn": [
									{
										"activity": "Execute Create Table",
										"dependencyConditions": [
											"Succeeded"
										]
									}
								],
								"policy": {
									"timeout": "7.00:00:00",
									"retry": 0,
									"retryIntervalInSeconds": 30,
									"secureOutput": false,
									"secureInput": false
								},
								"userProperties": [],
								"typeProperties": {
									"functionName": "GetSourceTargetMapping",
									"method": "POST",
									"body": {
										"value": "@json(\n concat('{\"TaskInstanceId\":\"', \n  string(pipeline().parameters.TaskObject.TaskInstanceId), \n  '\",\"ExecutionUid\":\"', \n  string(pipeline().parameters.TaskObject.ExecutionUid), \n  '\",\"RunId\":\"', \n  string(pipeline().RunId), \n  '\",\"StorageAccountName\":\"', \n  string(pipeline().parameters.TaskObject.Source.System.SystemServer), \n  '\",\"StorageAccountContainer\":\"', \n  string(pipeline().parameters.TaskObject.Source.System.Container), \n  '\",\"RelativePath\":\"', \n  string(pipeline().parameters.TaskObject.Source.Instance.SourceRelativePath), \n  '\",\"SchemaFileName\":\"', \n  string(pipeline().parameters.TaskObject.Source.SchemaFileName), \n  '\",\"SourceType\":\"', \n  if(\n     contains(string(pipeline().parameters.TaskObject.Source.System.SystemServer),'.dfs.core.windows.net'),\n     'ADLS',\n     'Azure Blob'\n    ), \n  '\",\"TargetType\":\"', \n  string(pipeline().parameters.TaskObject.Target.System.Type), \n  '\",\"MetadataType\":\"Parquet\"}')\n)",
										"type": "Expression"
									}
								},
								"linkedServiceName": {
									"referenceName": "SLS_AzureFunctionApp",
									"type": "LinkedServiceReference"
								}
							}
						]
					}
				},
				{
					"name": "Copy to SQL",
					"type": "Copy",
					"dependsOn": [
						{
							"activity": "If Auto Create Table",
							"dependencyConditions": [
								"Succeeded"
							]
						}
					],
					"policy": {
						"timeout": "7.00:00:00",
						"retry": 0,
						"retryIntervalInSeconds": 30,
						"secureOutput": false,
						"secureInput": false
					},
					"typeProperties": typeProperties(generateArmAsBool, GFPIR, SourceType, SourceFormat, TargetType, "NA"),
					"inputs": [dataset_inputs[SourceFormat](generateArmAsBool, SourceType, GFPIR, 'Source')],
                	"outputs": [dataset_outputs[TargetType](generateArmAsBool, TargetType, GFPIR, 'Target')],
					"userProperties": []
				},
					//+Main_CopyActivity_TypeProperties(GenerateArm, GFPIR, SourceType, SourceFormat, TargetType, "NA"),					
				{
					"name": "Pipeline AF Log - ADLS to Azure SQL Failed",
					"type": "ExecutePipeline",
					"dependsOn": [
						{
							"activity": "Copy to SQL",
							"dependencyConditions": [
								"Failed"
							]
						}
					],
					"userProperties": [],
					"typeProperties": {
						"pipeline": {
							"referenceName": "SPL_AzureFunction",
							"type": "PipelineReference"
						},
						"waitOnCompletion": false,
						"parameters": {
							"Body": {
								"value": "@json(concat('{\"TaskInstanceId\":\"', string(pipeline().parameters.TaskObject.TaskInstanceId), '\",\"ExecutionUid\":\"', string(pipeline().parameters.TaskObject.ExecutionUid), '\",\"RunId\":\"', string(pipeline().RunId), '\",\"LogTypeId\":1,\"LogSource\":\"ADF\",\"ActivityType\":\"Copy to SQL\",\"StartDateTimeOffSet\":\"', string(pipeline().TriggerTime), '\",\"EndDateTimeOffSet\":\"', string(utcnow()), '\",\"Comment\":\"', encodeUriComponent(string(activity('Copy to SQL').error.message)), '\",\"Status\":\"Failed\"}'))",
								"type": "Expression"
							},
							"FunctionName": "Log",
							"Method": "Post"
						}
					}
				},			
				{
					"name": "Pipeline AF Log - ADLS to Azure SQL Succeed",
					"type": "ExecutePipeline",
					"dependsOn": [
						{
							"activity": "Copy to SQL",
							"dependencyConditions": [
								"Succeeded"
							]
						}
					],
					"userProperties": [],
					"typeProperties": {
						"pipeline": {
							"referenceName": "SPL_AzureFunction",
							"type": "PipelineReference"
						},
						"waitOnCompletion": false,
						"parameters": {
							"Body": {
								"value": "@json(concat('{\"TaskInstanceId\":\"', string(pipeline().parameters.TaskObject.TaskInstanceId), '\",\"ExecutionUid\":\"', string(pipeline().parameters.TaskObject.ExecutionUid), '\",\"RunId\":\"', string(pipeline().RunId), '\",\"LogTypeId\":1,\"LogSource\":\"ADF\",\"ActivityType\":\"Copy to SQL\",\"StartDateTimeOffSet\":\"', string(pipeline().TriggerTime), '\",\"EndDateTimeOffSet\":\"', string(utcnow()), '\",\"RowsInserted\":\"', string(activity('Copy to SQL').output.rowsCopied), '\",\"Comment\":\"\",\"Status\":\"Complete\"}'))",
								"type": "Expression"
							},
							"FunctionName": "Log",
							"Method": "Post"
						}
					}
				},
				{
					"name": "Execute AZ_SQL_Post-Copy",
					"type": "ExecutePipeline",
					"dependsOn": [
						{
							"activity": "Pipeline AF Log - ADLS to Azure SQL Succeed",
							"dependencyConditions": [
								"Succeeded"
							]
						}
					],
					"userProperties": [],
					"typeProperties": {
						"pipeline": {
							"referenceName": 	if(GenerateArm=="false") 
												then "GPL_"+TargetType+"_"+"NA" + "_Post_Copy_"+ GFPIR
												else "[concat('GPL_"+TargetType+"_"+"NA" + "_Post_Copy_"+"', parameters('integrationRuntimeShortName'))]",
							"type": "PipelineReference"
						},
						"waitOnCompletion": true,
						"parameters": {
							"TaskObject": {
								"value": "@pipeline().parameters.TaskObject",
								"type": "Expression"
							}
						}
					}
				}
			],
			"parameters": {
				"TaskObject": {
					"type": "object"
				}
			},
			"folder": {
				"name": if(GenerateArm=="false") 
						then "ADS Go Fast/Data Movement/Azure-Storage-to-SQL-Database/" + GFPIR
						else "[concat('ADS Go Fast/Data Movement/Azure-Storage-to-SQL-Database/', parameters('integrationRuntimeShortName'))]",
			},
			"annotations": [],
			"lastPublishTime": "2020-07-29T09:43:40Z"
		},
		"type": "Microsoft.DataFactory/factories/pipelines"
	};
	
	Wrapper(GenerateArm,pipeline)+{}




