<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group_template_deployment.sh_pipelines](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_resource_group_template_deployment.sh_pipelines_level_0](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_resource_group_template_deployment.sh_pipelines_level_1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_factory_name"></a> [data\_factory\_name](#input\_data\_factory\_name) | The name of the data factory | `string` | n/a | yes |
| <a name="input_integration_runtime_name"></a> [integration\_runtime\_name](#input\_integration\_runtime\_name) | The name of the integration runtime | `string` | n/a | yes |
| <a name="input_integration_runtime_short_name"></a> [integration\_runtime\_short\_name](#input\_integration\_runtime\_short\_name) | The short name of the integration runtime | `string` | n/a | yes |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Used to give resource group deployments unique names for an environment | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group to deploy into | `string` | n/a | yes |
| <a name="input_shared_keyvault_uri"></a> [shared\_keyvault\_uri](#input\_shared\_keyvault\_uri) | The uri of the shared keyvault | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->