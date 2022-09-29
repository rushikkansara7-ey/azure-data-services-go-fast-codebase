function()
{
      
    "type": "object",
    "properties": {
        "Type": {
            "type": "string",                   
            "enum": [
                "Json"
            ],
            "options": {
                "hidden":true,
                "infoText": "Presently only Json is supported"
            }
        },
        "RelativePath": {
            "type": "string",
            "options": {
                "inputAttributes": {
                    "placeholder": "AwSample/dbo/Customer/{yyyy}/{MM}/{dd}/{hh}/"
                },
                "infoText": "The path of the directory into which you want your extracted data to be written. You can use placeholders such (eg. {yyyy}/{MM}/{dd}/{hh}/). "
            }
        },
        "DataFileName": {
            "type": "string",
            "options": {
                "inputAttributes": {
                    "placeholder": "dbo.Customer.parquet"
                },
                "infoText": "Name of the file that will hold the extracted data"
            }
        }
    },
    "required": [
        "Type",
        "RelativePath",
        "DataFileName"
     ]

}