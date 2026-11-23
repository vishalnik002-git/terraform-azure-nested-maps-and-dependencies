output "storage_id" {
  value = { for k, v in azurerm_storage_account.app_sa : k => v.id }
}
