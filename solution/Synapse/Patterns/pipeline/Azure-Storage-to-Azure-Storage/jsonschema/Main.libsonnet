local partials = {
   "Parquet": import "Partial_Parquet.libsonnet",
   "Delta": import "Partial_Delta.libsonnet"   
};


function(SourceType = "Parquet", SourceFormat = "Delta",TargetType = "AzureSqlTable", TargetFormat = "Delta")
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "title": "TaskMasterJson",
    "properties": {
        "CDCSource": {
            "type": "string",
            "default": "Disabled",
            "enum": [
                "Enabled",
                "Disabled"
            ],
            "options": {
                "infoText": "(required) Set this to enabled if your incoming data is from a CDC formatted database. This will modify how the default notebook interacts with the source data. Note: CDC specific columns will be removed from the sink."
            }
        },
        "SparkTableCreate": {
            "type": "string",
            "default": "Disabled",
            "enum": [
                "Enabled",
                "Disabled"
            ],
            "options": {
                "infoText": "(required) Set this to enabled if you want to save your output data as an external persistent table within synapse. Note: Currently persistent tables do not support delta format so we have to create a parquet of the latest version within the sink directory."
            }
        },
        "SparkTableDBName": {
            "type": "string",
            "options": {
                "inputAttributes": {
                    "placeholder": "eg. AdventureWorks"
                },
                "infoText": "(optional) This is the database of the persistent table you want to save. Will create a DB if provided name does not already exist. Note: This relies on SaveAsPersistentTable being Enabled - otherwise does nothing."
            }
        },
        "SparkTableName": {
            "type": "string",
            "options": {
                "inputAttributes": {
                    "placeholder": "eg. Customer"
                },
                "infoText": "(optional) This is the table name of the persistent table you want to save. Will create a table if provided name does not already exist. Note: This relies on SaveAsPersistentTable being Enabled - otherwise does nothing."
            }
        },
        "Purview": {
            "type": "string",
            "default": "Disabled",
            "enum": [
                "Enabled",
                "Disabled"
            ],
            "options": {
                "infoText": "(required) Use this to enable the pipeline to be written to purview. Note: This will not work if Purview is not enabled and configured with the ExecutionEngine."
            }
        },
        "QualifiedIDAssociation": {
            "type": "string",
            "default": "TaskMasterId",
            "enum": [
                "ExecutionId",
                "TaskMasterId"
            ],
            "options": {
                "infoText": "(optional) This is used to enable Purview to direct the QualifiedID (UID) to attach itself to the chosen ID. Note: If attached to the ExecutionId each indiviudal run of the pipeline will have a lineage."
            }
        },  
        "UseNotebookActivity": {
            "type": "string",
            "default": "Disabled",
            "enum": [
                "Enabled",
                "Disabled"
            ],
            "options": {
                "infoText": "(required) This flag is used to control the method used to call the Synapse Notebook that carries out the processing. When Enabled the default notebook activity type within Synapse pipelines will be used. Note that this will force a new spark session for each job execution. By leaving this flag disabled an Azure Function is used to call the notebook and Spark Sessions will be reused if available."
            }
        },    
        "Source": partials[SourceFormat](),
        "Target": partials[TargetFormat]()
    },
    "required": [
        "CDCSource",
        "SparkTableCreate",
        "Source",
        "Target",
        "Purview",
        "UseNotebookActivity"
    ]
}