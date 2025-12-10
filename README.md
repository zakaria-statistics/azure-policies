# Compute Lab Terraform Project

This repository contains Terraform configurations for setting up a compute lab environment.

## Project Structure

- `modules/`: Reusable building blocks for network, compute, and policy components.
- `envs/dev`: Root Terraform configuration for the development environment.
- `envs/prod`: Root Terraform configuration for the production environment.

## Getting Started

To get started with this project, ensure you have Terraform installed and configured for your cloud provider.

1. Choose an environment directory (`envs/dev` or `envs/prod`) and `cd` into it.
2. Populate or adjust that environment's `terraform.tfvars`.
3. Initialize Terraform from inside the chosen directory:
   ```bash
   terraform init
   ```
4. Plan the infrastructure:
   ```bash
   terraform plan
   ```
5. Apply the infrastructure:
   ```bash
   terraform apply
   ```

## Environment Layout

- Each environment directory contains a full Terraform root (provider config, locals, module wiring, and outputs) and manages its own state file.
- The reusable modules under `modules/` stay identical across environments; only the variable values in each environment's `terraform.tfvars` change.
- To add new environments, copy one of the existing directories, adjust the `.tfvars`, and run Terraform from the new path.

## Resources

[Link to Terraform documentation](https://www.terraform.io/docs/)
[Link to Azure Provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
