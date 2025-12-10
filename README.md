# Compute Lab Terraform Project

This repository contains Terraform configurations for setting up a compute lab environment.

## Project Structure

- `main.tf`: Main Terraform configuration file.
- `variables.tf`: Input variables for the Terraform configuration.
- `outputs.tf`: Output values from the Terraform configuration.
- `provider.tf`: Provider configuration (e.g., Azure).
- `compute.tf`: Defines compute resources.
- `network.tf`: Defines network resources.
- `policies.tf`: Defines policy resources.

## Getting Started

To get started with this project, ensure you have Terraform installed and configured for your cloud provider.

1. Pick an environment in `terraform.tfvars` (e.g., `environment = "dev"`). Each environment pulls its own RG name, location, networking ranges, VM size, etc. from the `environment_configs` map. Override individual variables (like `location`, `vm_size`, …) only when you need to drift from the defaults.
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Plan the infrastructure:
   ```bash
   terraform plan
   ```
4. Apply the infrastructure:
   ```bash
   terraform apply
   ```

## Environment Configuration

- `environment` selects the key inside `environment_configs` (defaults include `dev` and `prod`).
- `environment_configs` is a map of per-environment values (resource group name, region, CIDRs, VM sizes, policy filters, etc.). Add new keys or tweak existing ones in `terraform.tfvars`.
- Any root variable with a `null` default (e.g., `location`, `vm_size`, `vnet_cidr`) acts as an override. Set it in `terraform.tfvars` to diverge from the environment default without rewriting the whole map.

## Resources

[Link to Terraform documentation](https://www.terraform.io/docs/)
[Link to Azure Provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
