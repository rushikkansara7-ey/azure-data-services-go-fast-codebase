locals {
  common_vars = jsondecode(file("../../../../bin/environments/staging/common_vars_for_hcl.json"))
}


generate "layer0.tf" {
  path      = "layer0.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    data "terraform_remote_state" "layer0" {
      # The settings here should match the "backend" settings in the
      # configuration that manages the network resources.
      backend = "azurerm"
      
      config = {
        container_name       = "tstate"
        key                  = "terraform_layer0.tfstate"
        resource_group_name  = "${local.common_vars.resource_group_name}"
        storage_account_name = "${local.common_vars.state_storage_account_name}"
      }
    }
  EOF
}

generate "layer2.tf" {
  path      = "layer2.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    data "terraform_remote_state" "layer2" {
      # The settings here should match the "backend" settings in the
      # configuration that manages the network resources.
      backend = "azurerm"
      
      config = {
        container_name       = "tstate"
        key                  = "terraform_layer2.tfstate"
        resource_group_name  = "${local.common_vars.resource_group_name}"
        storage_account_name = "${local.common_vars.state_storage_account_name}"
      }
    }
  EOF
}

remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    # You need to update the resource group and storage account here. 
    # You should have created these with the Prepare.ps1 script.
    resource_group_name  = "${local.common_vars.resource_group_name}"
    storage_account_name = "${local.common_vars.state_storage_account_name}"
    container_name       = "tstate"
    key                  = "terraform_ixup.tfstate"
  }
}
