# 1. Provisioning Resource Groups from Nested Map
resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups
  name     = each.key
  location = each.value.location
}

# 2. Provisioning Storage Accounts linked via Implicit Dependency
# By referencing azurerm_resource_group.rg[each.value.rg_name].name,
# Terraform builds an implicit dependency graph: the specific Resource Group
# is guaranteed to exist before this Storage Account is created.
resource "azurerm_storage_account" "sa" {
  for_each                 = var.storage_workloads
  name                     = each.key
  resource_group_name      = azurerm_resource_group.rg[each.value.rg_name].name
  location                 = azurerm_resource_group.rg[each.value.rg_name].location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.redundancy
}
