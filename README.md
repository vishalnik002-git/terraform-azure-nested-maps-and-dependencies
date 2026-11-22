# ⚙️ Terraform Azure Multi-Resource Automation with Nested Maps & `for_each`

[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Microsoft_Azure-0078D4?style=flat&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![IaC](https://img.shields.io/badge/IaC-Automation-blue)](https://developer.hashicorp.com/terraform)

---

## 📌 Project Overview

This project demonstrates how to automate the provisioning of multiple **Azure Resource Groups** and **Storage Accounts** across different Azure regions using **Terraform Nested Maps** and **`for_each` loops**.

Instead of copy-pasting resource blocks for every environment or region, this project follows the **DRY (Don't Repeat Yourself)** principle by defining resource metadata in structured maps and iterating dynamically.

---

## 🏗️ Architecture & Resources Provisioned

```text
Terraform for_each Execution
  ├── Resource Group: rg-anything-01 (East US)
  │     └── Storage Account: vishalstorage2401 (Standard_LRS)
  │
  └── Resource Group: rg-anything-02 (West US)
        └── Storage Account: vishalstorage2406 (Standard_LRS)
```

1. **Dynamic Resource Groups (`azurerm_resource_group.rg_mohala`):**
   - Provisions multiple resource groups dynamically across `East US` and `West US`.
   - Tags management metadata (`managed_by = "microsoft"`).
2. **Dynamic Storage Accounts (`azurerm_storage_account.prod_storage`):**
   - Provisions corresponding storage accounts with `Standard` tier and `LRS` replication.
   - Enforces **Explicit Dependency** (`depends_on`) ensuring Resource Groups exist before storage account provisioning starts.

---

## 💡 Key DevOps Concepts Demonstrated

* **Nested Maps in HCL:** Defining complex multi-attribute configurations (region, tier, replication, resource group) in a single hierarchical map structure.
* **`for_each` Iteration:** Looping over map keys (`each.key`) and values (`each.value`) to dynamically create cloud resources without code duplication.
* **Explicit Dependency (`depends_on`):** While Terraform automatically handles implicit dependencies through resource references, `depends_on` is explicitly declared to enforce strict creation ordering.
* **Azure Naming Constraints:** Adhering to strict Azure naming rules for Storage Accounts (globally unique, 3-24 characters, numbers and lowercase letters only — no hyphens or underscores).

---

## 📁 Repository Structure

```text
.
├── main.tf              # Resource definitions, nested maps, and for_each loops
├── provider.tf          # AzureRM provider configuration
├── .gitignore           # Git ignore rules for state and secret files
└── README.md            # Project documentation
```

---

## 🚀 How to Run

### Prerequisites
* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) authenticated (`az login`)
* [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) (>= 1.5.0)

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/vishalnik002-git/terraform-azure-rg-storage-automation.git
cd terraform-azure-rg-storage-automation

# 2. Authenticate to Azure
az login

# 3. Initialize Terraform
terraform init

# 4. Validate syntax
terraform validate

# 5. Preview planned infrastructure
terraform plan

# 6. Apply configuration
terraform apply -auto-approve
```

---

## 🧹 Clean Up

To destroy all provisioned resources and prevent cloud charges:

```bash
terraform destroy -auto-approve
```

---

## 👤 Author
* **Vishal Yadav** — [GitHub Profile](https://github.com/vishalnik002-git) | [LinkedIn](https://www.linkedin.com/in/vishal-yadav002)
