# Demonstration of EXPLICIT dependency using depends_on
# In real architectures, explicit dependencies are used when Terraform cannot
# infer the relationship through property references alone (e.g. logging/monitoring,
# IAM role assignments, or governance policies that must exist prior to workload deployment).

resource "azurerm_resource_group" "primary" {
  name     = "rg-primary-infra"
  location = var.location
}

resource "azurerm_resource_group" "secondary" {
  name     = "rg-secondary-infra"
  location = var.location

  # Explicit dependency declaration:
  # secondary RG will only be provisioned after primary RG finishes successfully.
  depends_on = [
    azurerm_resource_group.primary
  ]
}
