variable "storage_map" {
  type = map(object({
    location = string
    tier     = string
    rep      = string
  }))
  default = {
    "stappshared01" = {
      location = "eastus"
      tier     = "Standard"
      rep      = "LRS"
    }
  }
}
