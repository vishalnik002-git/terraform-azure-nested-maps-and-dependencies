resource"azurerm_resource_group""rg_mohala"{
    for_each = {
         "rg-anything-01" = {
            "location" = "East us"
            "managed_by"= "microsoft"
        }
        "rg-anything-02" = {
            location = "West US"
            managed_by = "microsoft"
        }
    }

               name = each.key
               location = each.value.location
               managed_by = each.value.managed_by
}


# STORAGE ACCOINT BY NESTED MAP

resource"azurerm_storage_account""prod_storage"{
    for_each = {
        vishalstorage2401 ={                        # AZURE STORAGE ACCOUNT DOES NOT ALLOW:UNDERSCORE (_), HYPHEN (-), UPPERCASE LETTERS.
        resource_group_name = "rg-anything-01"
        location = "East US"
        tier = "Standard"
        redundancy = "LRS"
        
         }
            vishalstorage2406 = {
            resource_group_name = "rg-anything-02"
            location = "West US"
            tier = "Standard"
            redundancy ="LRS"
            }    
    }

                  name = each.key
                  resource_group_name = each.value.resource_group_name
                  location = each.value.location
                  account_tier = each.value.tier
                  account_replication_type = each.value.redundancy
                  depends_on = [azurerm_resource_group.rg_mohala ] # HERE WE USE EXPLICIT DEPENDENCY

        }