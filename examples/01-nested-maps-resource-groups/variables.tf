variable "environments" {
  type = map(object({
    location = string
  }))
  default = {
    "rg-dev-core"  = { location = "eastus" }
    "rg-test-core" = { location = "centralus" }
  }
}
