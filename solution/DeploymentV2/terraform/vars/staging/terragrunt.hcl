remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    # You need to update the resource group and storage account here. 
    # You should have created these with the Prepare.ps1 script.
    resource_group_name  = "gft2"
    storage_account_name = "gft2state"
    container_name       = "tstate"
    key                  = "terraform.tfstate"
  }
}

# These inputs are provided to the terraform variables when deploying the environment
# If you are deploying using pipelines, these can be overridden from environment variables
# using TF_VAR_variablename
inputs = {
  prefix                                = "ads"              # All azure resources will be prefixed with this
  domain                                = "microsoft.com"              # Used when configuring AAD config for Azure functions 
  tenant_id                             = "72f988bf-86f1-41af-91ab-2d7cd011db47"           # This is the Azure AD tenant ID
  subscription_id                       = "035a1364-f00d-48e2-b582-4fe125905ee3"     # The azure subscription id to deploy to
  resource_location                     = "Australia East"        # The location of the resources
  resource_group_name                   = "gft2"          # The resource group all resources will be deployed to
  owner_tag                             = "Contoso"               # Owner tag value for Azure resources
  environment_tag                       = "stg"                   # This is used on Azure tags as well as all resource names
  ip_address                            = "144.138.148.220"          # This is the ip address of the agent/current IP. Used to create firewall exemptions.
  deploy_web_app                        = true
  deploy_function_app                   = true
  deploy_custom_terraform               = false # This is whether the infrastructure located in the terraform_custom folder is deployed or not.
  deploy_app_service_plan               = true
  deploy_data_factory                   = true
  deploy_sentinel                       = true
  deploy_purview                        = true      
  deploy_synapse                        = true
  deploy_metadata_database              = true
  is_vnet_isolated                      = true
  publish_web_app                       = true
  publish_function_app                  = true
  publish_sample_files                  = true
  publish_metadata_database             = true
  configure_networking                  = true
  publish_datafactory_pipelines         = true
  publish_web_app_addcurrentuserasadmin = true
  deploy_selfhostedsql                  = false
  is_onprem_datafactory_ir_registered   = false
  publish_sif_database                  = true
} 
