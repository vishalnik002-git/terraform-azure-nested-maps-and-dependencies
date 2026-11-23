output "ordered_rgs" {
  value = [
    azurerm_resource_group.primary.name,
    azurerm_resource_group.secondary.name
  ]
}
