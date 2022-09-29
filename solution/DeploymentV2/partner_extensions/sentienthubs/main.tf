# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.20.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.28.0"
    }
    azapi = {
      source  = "Azure/azapi"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.3.2"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  subscription_id            = var.subscription_id
  skip_provider_registration = true
}

provider "azuread" {
  tenant_id = var.tenant_id
}

data "azurerm_client_config" "current" {
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.2.0"
  unique-seed = data.terraform_remote_state.layer2.outputs.naming_unique_seed
  prefix = [
    var.prefix,
    var.environment_tag
  ]
  suffix = [
    var.app_name
  ]
}

resource "random_id" "rg_deployment_unique" {
  byte_length = 4
}
