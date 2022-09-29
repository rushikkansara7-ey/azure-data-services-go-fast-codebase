function() 
{
            "type": "object",
            "properties": {
                "Type": {
                    "type": "string",                    
                    "enum": [
                        "Excel"
                    ], 
                    "options":{
                        "hidden": true
                    }
                },
                "RelativePath": {
                    "type": "string",
                    "options": {
                        "inputAttributes": {
                            "placeholder": "eg. AwSample/dbo/Customer/{yyyy}/{MM}/{dd}/{hh}/"
                        },
                        "infoText": "(optional) Path of the file to be imported."
                    }
                },
                "DataFileName": {
                    "type": "string",
                    "options": {
                        "inputAttributes": {
                            "placeholder": "eg. Customer.xlsx"
                        },
                        "infoText": "(required) Name of the file to be imported."
                    }
                },
                "SchemaFileName": {
                    "type": "string",             
                    "options": {
                        "inputAttributes": {
                            "placeholder": "eg. Customer_Schema.json"
                        },
                        "infoText": "(required) Name of the schema file to use when generating the target table. *Note that if you do not provide a schema file then the schema will be automatically inferred based on the source data."
                    }
                },
                "FirstRowAsHeader": {
                    "type": "string",
                    "enum": [
                        "true",
                        "false"
                    ],
                    "default": "true",
                    "options": {                        
                        "infoText": "(required) Set to true if you want the first row of data to be used as column names."
                    }
                },
                "SheetName": {
                    "type": "string",
                    "options": {
                        "inputAttributes": {
                            "placeholder": "eg. Sheet1"
                        },
                        "infoText": "(required) Name of the Excel Worksheet that you wish to import"
                    }
                }        
            },
            "required": [
                "Type",
                "RelativePath",
                "DataFileName",
                "SchemaFileName",
                "FirstRowAsHeader",
                "SheetName"
            ]
 
}