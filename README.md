# 🗺️ Nested Maps & Dependency Management in Terraform

![Terraform Version](https://img.shields.io/badge/Terraform-1.5%2B-blue.svg?logo=terraform)
![Azure Provider](https://img.shields.io/badge/AzureRM-3.100%2B-0078D4.svg?logo=microsoft-azure)
![IaC](https://img.shields.io/badge/IaC-Nested%20Maps-623CE4.svg)
![Validation](https://img.shields.io/badge/Validation-Pass-success.svg)

> **Repository 05 of 08 in the Terraform + Microsoft Azure Professional Learning Series**

---

## 📌 Navigation
| ⏪ Previous Repository | 📚 Current Repository | ⏩ Next Repository |
| :--- | :---: | :--- |
| [← 04. terraform-azure-collections-and-loops](https://github.com/vishalnik002-git/terraform-azure-collections-and-loops) | **05. terraform-azure-nested-maps-and-dependencies** | [06. terraform-azure-state-management →](https://github.com/vishalnik002-git/terraform-azure-state-management) |

---

## 📖 Project Overview

Enterprise cloud architectures require deploying multi-tier environments (e.g. web, API, data tiers) where resources have diverse configurations and specific deployment dependencies.
This repository explores:
1. **Nested Maps**: Complex data structures where map values are typed `object` schemas holding multiple properties.
2. **Implicit Dependencies**: Letting Terraform's Directed Acyclic Graph (DAG) infer order through resource attribute references.
3. **Explicit Dependencies (`depends_on`)**: Defining explicit ordering when relationships are invisible to Terraform's attribute parser.
4. **Terraform Meta-arguments**: `depends_on`, `count`, `for_each`, and `lifecycle`.

> ℹ️ **Learning Note**: This repository contains learning configurations and documentation. Automated validation checks verify HCL syntax without provisioning live Azure cloud resources.

---

## 🎯 Learning Objectives

By exploring this repository, you will understand:
1. How to define nested map schemas using `map(object({...}))`.
2. How to iterate over nested maps using `for_each` and extract individual fields:
   - `each.key`: Map key (e.g. resource name).
   - `each.value.location`: Target region.
   - `each.value.rg_name`: Associated parent Resource Group key.
   - `each.value.account_tier`: Service tier.
   - `each.value.redundancy`: Replication type.
3. The exact difference between a **Resource Reference** (`azurerm_resource_group.rg[key].name`) and variable input lookup.
4. When to rely on implicit dependency vs when explicit `depends_on` is required.
5. Best practice: Avoiding unnecessary `depends_on` when attribute references already exist.

---

## 🏗️ Dependency Architecture & Graph

```
+---------------------------------------------------------------------------------+
|                         Resource Graph & Linking                                |
+---------------------------------------------------------------------------------+

 1. Provision Resource Groups (for_each over var.resource_groups)
    [ azurerm_resource_group.rg["rg-web-prod"] ]     [ azurerm_resource_group.rg["rg-data-prod"] ]
                         |                                                |
                         | (Implicit Dependency via                       | (Implicit Dependency via
                         |  azurerm_resource_group.rg[key].name)          |  azurerm_resource_group.rg[key].name)
                         v                                                v
    [ azurerm_storage_account.sa["stwebstaticprod01"] ] [ azurerm_storage_account.sa["stdatapipelinedev01"] ]
```

---

## 📂 Repository Structure

```
terraform-azure-nested-maps-and-dependencies/
├── .github/
│   └── workflows/
│       └── validate.yml          # GitHub Actions CI validation pipeline
├── examples/
│   ├── 01-nested-maps-resource-groups/ # Nested map iteration for RGs
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   ├── 02-implicit-dependency-rg-storage/ # Attribute referencing demo
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── versions.tf
│   └── 03-explicit-dependency-depends-on/ # depends_on demonstration
│       ├── main.tf
│       ├── outputs.tf
│       ├── variables.tf
│       └── versions.tf
├── .gitignore                    # Git exclusion rules
├── main.tf                       # Primary nested map & dependency configuration
├── outputs.tf                    # Structured output maps
├── providers.tf                  # AzureRM provider configuration
├── terraform.tfvars.example      # Sample multi-tier dataset
├── variables.tf                  # Nested map type declarations
├── versions.tf                   # Version constraint declarations
└── README.md                     # Comprehensive documentation
```

---

## 🧩 Technical Concepts

### 1. Nested Map Schema Declaration
A nested map binds a string key to an object with distinct typed fields:
```hcl
variable "storage_workloads" {
  type = map(object({
    rg_name      = string
    location     = string
    account_tier = string
    redundancy   = string
  }))
}
```

### 2. Implicit Dependency via Resource Linking
When provisioning storage accounts, referencing the Resource Group object directly builds an implicit dependency:
```hcl
resource "azurerm_storage_account" "sa" {
  for_each                 = var.storage_workloads
  name                     = each.key
  resource_group_name      = azurerm_resource_group.rg[each.value.rg_name].name
  location                 = azurerm_resource_group.rg[each.value.rg_name].location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.redundancy
}
```

### 3. Explicit Dependency (`depends_on`)
Used only when an ordering requirement is **not** expressed through attribute references:
```hcl
resource "azurerm_resource_group" "secondary" {
  name       = "rg-secondary"
  location   = "eastus"
  depends_on = [azurerm_resource_group.primary]
}
```
> 💡 **Best Practice**: Never add `depends_on` if the resource already references `azurerm_resource_group.rg.name`. Redundant `depends_on` bloats the dependency graph and slows down plan generation.

---

## 🛠️ Step-by-Step Getting Started Guide

### Prerequisites
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) (v1.5.0+).

### 1. Format Code
```bash
terraform fmt
```

### 2. Initialize Working Directory
```bash
terraform init -backend=false
```

### 3. Validate Configuration
```bash
terraform validate
```

### 4. Review Plan (Educational Documentation)
```bash
terraform plan -var-file="terraform.tfvars.example"
```

### 5. Apply Changes (Educational Documentation)
```bash
terraform apply
```
> ⚠️ **IMPORTANT**: In production, `terraform apply` requires manual confirmation. In this educational repository, no cloud deployment is executed.

---

## 🔄 Terraform Resource Lifecycle & Destruction Concepts

1. **Dependency-Aware Destruction**:
   Terraform tears down infrastructure in reverse dependency order. Even when using nested maps with dozens of resources, Terraform will safely destroy all storage accounts before attempting to destroy their parent Resource Groups.
2. **Impact of Modifying Map Keys**:
   Renaming a key in a nested map causes Terraform to treat the resource as a new object: it will destroy the old resource and provision a new one. Review `terraform plan` thoroughly before modifying map keys.

---

## 🤖 CI/CD Automation (GitHub Actions)

This repository includes a continuous integration workflow in `.github/workflows/validate.yml` that validates syntax across the root module and all 3 example directories on every push and pull request.

---

## 👨‍💻 Author Information

- **Developer**: Vishal Yadav (`vishalnik002-git`)
- **Education**: MCA @ Galgotias University (2025–2027) | BCA @ MGKVP (2022–2025)
- **Role**: DevOps Intern @ DevOps Insiders
- **GitHub Profile**: [https://github.com/vishalnik002-git](https://github.com/vishalnik002-git)
