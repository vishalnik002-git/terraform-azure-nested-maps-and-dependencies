output "rg_ids" {
  value = { for k, v in azurerm_resource_group.env_rgs : k => v.id }
}
