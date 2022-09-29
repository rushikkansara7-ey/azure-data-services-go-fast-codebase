local partials = {
    "Rest": import "Partial_SourceRest.libsonnet",
    "Json": import "Partial_TargetJson.libsonnet"
};


function(SourceType = "", SourceFormat = "Rest",TargetType = "", TargetFormat = "Json")
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "title": "TaskMasterJson",
    "properties": {
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
                "infoText": "(optional) This is used to enable Purview to direct the QualifiedID (UID) to attach itself to the relevant ID. Note: If attached to the ExecutionID each indiviudal run of the pipeline with have a lineage."
            }
        }, 
        "ExecuteNotebook": {
            "type": "string",
            "options": {
                "inputAttributes": {
                    "placeholder": "RestAPINotebook"
                },
                "infoText": "(required) WARNING: Only change this if you wish to use a custom notebook for the REST API procedure."
            },
            "default":"RestAPINotebook"
        },
        "Source": partials[SourceFormat](),
        "Target": partials[TargetFormat](),
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
        }
    },
    "required": [
        "ExecuteNotebook",
        "Purview",
        "UseNotebookActivity"
    ]
}