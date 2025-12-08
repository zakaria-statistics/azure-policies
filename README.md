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

1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Plan the infrastructure:
   ```bash
   terraform plan
   ```
3. Apply the infrastructure:
   ```bash
   terraform apply
   ```

## Resources

[Link to Terraform documentation](https://www.terraform.io/docs/)
[Link to Azure Provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
