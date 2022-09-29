local partials = {
   "AzureSqlTable": import "Partial_LoadFromSql.libsonnet",
   "SqlServerTable": import "Partial_LoadFromSql.libsonnet",      
   "AzureSqlDWTable": import "Partial_LoadFromSql.libsonnet"
};


function(SourceType = "AzureSqlTable", SourceFormat = "",TargetType = "", TargetFormat = "")
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "type": "object",
    "title": "TaskMasterJson",
    "properties": {
        "Source": partials[SourceType](),
        "Target": partials[SourceType](),
        "SQLStatement": {
            "type": "string",            
            "options": {
                "infoText": "(required) SQL Statement/s to Execute. NOTE the last statement MUST return at least one row.",
                "inputAttributes": {
                    "placeholder": "eg. Exec StoredProcedure1; Select 1;"
                }               
            }
        },
        "QueryTimeout": {
            "type": "string",            
            "options": {
                "infoText": "(required) Timeout in the form hh:MM:ss. Eg. 2 hours would be 02:00:00",
                "inputAttributes": {
                    "placeholder": "eg. 02:00:00"
                }  
            }, 
            "default":"02:00:00"
        }
    },
    "required": [
        "Source",
        "Target",
        "SQLStatement",
        "QueryTimeout"
    ]
}