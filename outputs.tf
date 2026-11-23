output "created_resource_groups" {
  description = "Map of created Resource Groups and their IDs."
  value       = { for k, v in azurerm_resource_group.rg : k => v.id }
}

output "created_storage_endpoints" {
  description = "Map of created Storage Accounts and their primary blob endpoints."
  value       = { for k, v in azurerm_storage_account.sa : k => v.primary_blob_endpoint }
}
