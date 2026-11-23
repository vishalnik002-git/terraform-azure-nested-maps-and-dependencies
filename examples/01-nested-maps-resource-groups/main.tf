resource "azurerm_resource_group" "env_rgs" {
  for_each = var.environments
  name     = each.key
  location = each.value.location
}
