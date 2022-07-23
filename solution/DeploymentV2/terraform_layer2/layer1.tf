data "terraform_remote_state" "layer1" {
  # The settings here should match the "backend" settings in the
  # configuration that manages the network resources.
  backend = "azurerm"
  
  config = {
    container_name       = "tstate"
    key                  = "terraform_layer1.tfstate"
    resource_group_name  = "gft2"
    storage_account_name = "gft2state"
  }
}