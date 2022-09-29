function(seed=0)
local tests =
[
    {
        "Active": true,        
        "Pattern": "SQL Database to Azure Storage",         
        "SourceFormat":"Table",
        "SourceType":"Azure SQL",
        "ExtractionSQL":"",
        "DataFilename":"SalesLT.Customer.parquet",
        "SchemaFileName":"SalesLT.Customer.json",
        "SourceSystemAuthType": "MSI",
        "TargetFormat":"Parquet",
        "TargetType": "Azure Blob", 
        "ADFPipeline": "GPL_AzureSqlTable_NA_AzureBlobStorage_Parquet", 
        "Description": "FullLoad",
        "ChunkField":"",
        "ChunkSize":0,
        "IncrementalType": "Full",
        "TaskDatafactoryIR":"Azure"
    },
    {
        "Active": true,
        "Pattern": "SQL Database to Azure Storage",         
        "SourceFormat":"Table",
        "SourceType":"Azure SQL",
        "ExtractionSQL":"",
        "DataFilename":"SalesLT.Customer.parquet",
        "SchemaFileName":"SalesLT.Customer.json",
        "SourceSystemAuthType": "MSI",
        "TargetFormat":"Parquet",
        "TargetType": "ADLS",
        "ADFPipeline": "GPL_AzureSqlTable_NA_AzureBlobFS_Parquet",
        "Description": "FullLoad",
        "ChunkField":"",
        "ChunkSize":0,
         "IncrementalType": "Full",
        "TaskDatafactoryIR":"Azure"
    },
    {
        "Active": true,
        "Pattern": "SQL Database to Azure Storage",         
        "SourceFormat":"Table",
        "SourceType":"Azure SQL",
        "ExtractionSQL":"Select top 10 * from SalesLT.Customer",
        "DataFilename":"SalesLT.Customer.parquet",
        "SchemaFileName":"SalesLT.Customer.json",
        "SourceSystemAuthType": "MSI",
        "TargetFormat":"Parquet",
        "TargetType": "ADLS",
        "ADFPipeline": "GPL_AzureSqlTable_NA_AzureBlobFS_Parquet",
        "Description": "FullLoadUsingExtractionSql",
        "ChunkField":"",
        "ChunkSize":0,
        "IncrementalType": "Full",
        "TaskDatafactoryIR":"Azure"
    },    
    {
        "Active": true,
        "Pattern": "SQL Database to Azure Storage",         
        "SourceFormat":"Table",
        "SourceType":"Azure SQL",
        "ExtractionSQL":"Select top 10 * from SalesLT.Customer",
        "DataFilename":"SalesLT.Customer.parquet",
        "SchemaFileName":"SalesLT.Customer.json",
        "SourceSystemAuthType": "MSI",
        "TargetFormat":"Parquet",
        "TargetType": "ADLS",
        "ADFPipeline": "GPL_AzureSqlTable_NA_AzureBlobFS_Parquet",
        "Description": "FullLoadWithChunk",
        "ChunkField":"CustomerID",
        "ChunkSize":100,
        "IncrementalType": "Full",
        "TaskDatafactoryIR":"Azure"
    },    
    {
        "Active": true,
        "Pattern": "SQL Database to Azure Storage",         
        "SourceFormat":"Table",
        "SourceType":"Azure SQL",
        "ExtractionSQL":"Select top 10 * from SalesLT.Customer",
        "DataFilename":"SalesLT.Customer.parquet",
        "SchemaFileName":"SalesLT.Customer.json",
        "SourceSystemAuthType": "MSI",
        "TargetFormat":"Parquet",
        "TargetType": "ADLS",
        "ADFPipeline": "GPL_AzureSqlTable_NA_AzureBlobFS_Parquet",
        "Description": "IncrementalLoad",
        "ChunkField":"",
        "ChunkSize":0,
        "IncrementalType": "Watermark",
        "TaskDatafactoryIR":"Azure"
    },
    // Using OnPrem IR
    {
        "Active": true,
        "Pattern": "SQL Database to Azure Storage",         
        "SourceFormat":"Table",
        "SourceType":"SQL Server",
        "ExtractionSQL":"",
        "DataFilename":"dbo.all_objects.parquet",
        "SchemaFileName":"dbo_all_objects.json",
        "SourceSystemAuthType": "Windows",
        "TargetFormat":"Parquet",
        "TargetType": "ADLS",
        "ADFPipeline": "GPL_SqlServerTable_NA_AzureBlobFS_Parquet",
        "Description": "FullLoad",
        "ChunkField":"",
        "ChunkSize":0,
        "IncrementalType": "Full",
        "TaskDatafactoryIR":"OnPrem"
    },
    {
        "Active": true,
        "Pattern": "SQL Database to Azure Storage",         
        "SourceFormat":"Table",
        "SourceType":"SQL Server",
        "ExtractionSQL":"",
        "DataFilename":"dbo.all_objects.parquet",
        "SchemaFileName":"dbo_all_objects.json",
        "SourceSystemAuthType": "Windows",
        "TargetFormat":"Parquet",
        "TargetType": "Azure Blob",
        "ADFPipeline": "GPL_SqlServerTable_NA_AzureBlobStorage_Parquet_Primary_OnPrem",
        "Description": "FullLoad",
        "ChunkField":"",
        "ChunkSize":0,
        "IncrementalType": "Full",
        "TaskDatafactoryIR":"OnPrem"
    }
];

local template = import "./partials/functionapptest.libsonnet";

local process = function(index, t)
template(
    t.ADFPipeline,
    t.Pattern, 
    seed-index,//t.TestNumber,
    t.SourceFormat,
    t.SourceType,
    t.ExtractionSQL,
    t.DataFilename,
    t.SchemaFileName,
    t.SourceSystemAuthType,
    t.TargetFormat,
    t.TargetType,
    t.ChunkField,
    t.ChunkSize,
    t.IncrementalType,
    t.Description,
    t.TaskDatafactoryIR
);


std.mapWithIndex(process, tests)

