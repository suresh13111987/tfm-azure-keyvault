data "azurerm_client_config" "current_config" {

}

data "azurerm_resource_group" "main" {
  name = local.resource_group_name
}
