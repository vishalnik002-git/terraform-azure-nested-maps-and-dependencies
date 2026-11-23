# 1. Nested Map of Resource Groups
variable "resource_groups" {
  type = map(object({
    location = string
  }))
  description = "Nested map defining Resource Groups and their region configuration."
  default = {
    "rg-web-prod" = {
      location = "eastus"
    }
    "rg-data-prod" = {
      location = "centralus"
    }
  }
}

# 2. Nested Map of Storage Accounts linked to parent Resource Groups
variable "storage_workloads" {
  type = map(object({
    rg_name      = string
    location     = string
    account_tier = string
    redundancy   = string
  }))
  description = "Nested map defining storage workloads linked to parent Resource Groups."
  default = {
    "stwebstaticprod01" = {
      rg_name      = "rg-web-prod"
      location     = "eastus"
      account_tier = "Standard"
      redundancy   = "LRS"
    }
    "stdatapipelinedev01" = {
      rg_name      = "rg-data-prod"
      location     = "centralus"
      account_tier = "Standard"
      redundancy   = "GRS"
    }
  }
}
