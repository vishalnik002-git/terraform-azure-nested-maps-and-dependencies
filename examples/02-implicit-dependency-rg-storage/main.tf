resource "azurerm_resource_group" "base_rg" {
  name     = "rg-implicit-demo"
  location = "eastus"
}

# Implicit dependency is created by referencing base_rg attributes directly
resource "azurerm_storage_account" "app_sa" {
  for_each                 = var.storage_map
  name                     = each.key
  resource_group_name      = azurerm_resource_group.base_rg.name
  location                 = azurerm_resource_group.base_rg.location
  account_tier             = each.value.tier
  account_replication_type = each.value.rep
}
