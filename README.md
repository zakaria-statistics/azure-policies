# Compute Lab Terraform Project

Terraform configuration used to build and govern a small Azure “compute lab.”  
We now support multiple environments, reusable modules, and remote state stored in Azure Blob Storage.

## Repository Layout

- `modules/`
  - `network/` – creates the lab virtual network, subnet, and security rules.
  - `compute/` – provisions the Linux VM, NIC, public IP, and grants its managed identity `Contributor` on the RG.
  - `policy/` – defines custom Azure Policy definitions + initiative and assigns it to the lab resource group.
- `envs/dev` and `envs/prod`
  - Complete Terraform roots for each environment (providers, variables, module wiring, outputs, backend config).
  - Each directory has its own `terraform.tfvars` (credentials + parameters) and remote backend definition.

Add a new environment by copying one of the existing directories, updating `terraform.tfvars`, and pointing its backend at a new state container.

## Remote State

Each environment keeps state in a dedicated Azure Storage account + blob container:

| Environment | Storage RG                       | Storage Account       | Container | Key (blob name)            |
|-------------|----------------------------------|-----------------------|-----------|----------------------------|
| dev         | `rg-terraform-state-vault-dev`   | `tfstatedevwe1234`    | `tfstate` | `dev.terraform.tfstate`    |
| prod        | `rg-terraform-state-vault-prod`  | `tfstateprodne5678`   | `tfstate` | `prod.terraform.tfstate`   |

The backend configuration lives in `envs/<env>/backend.tf`. Azure Blob Storage automatically handles encryption at rest and Terraform handles locking via blob leases.

> Bootstrap note: storage accounts/containers are created via the separate `bootstrap/` workspace (or the equivalent `az` commands). Once they exist, run `terraform init -migrate-state` inside each environment to move any local state into the remote backend.

## Secrets via Key Vault

Provider credentials and VM SSH keys live in Azure Key Vault, so `terraform.tfvars` no longer carries secrets. Each environment reads them from its vault at runtime:

| Environment | Key Vault               | Resource Group                 | Required Secret Names                                      |
|-------------|-------------------------|--------------------------------|------------------------------------------------------------|
| dev         | `kv-terraform-dev-we-01`  | `rg-terraform-state-vault-dev`  | `terraform-sp-client-secret`, `terraform-admin-ssh-public-key` |
| prod        | `kv-terraform-prod-ne-01` | `rg-terraform-state-vault-prod` | `terraform-sp-client-secret`, `terraform-admin-ssh-public-key` |

Populate each secret once, e.g.:

```bash
az keyvault secret set \
  --vault-name kv-terraform-dev-we-01 \
  --name terraform-sp-client-secret \
  --value '<service-principal-secret>'

az keyvault secret set \
  --vault-name kv-terraform-dev-we-01 \
  --name terraform-admin-ssh-public-key \
  --value 'ssh-rsa AAAA...'
```

Configure the environment by pointing to the vault + secret names in `terraform.tfvars`:

```hcl
key_vault_name                   = "kv-terraform-dev-we-01"
key_vault_resource_group         = "rg-terraform-state-vault-dev"
client_secret_secret_name        = "terraform-sp-client-secret"
admin_ssh_public_key_secret_name = "terraform-admin-ssh-public-key"
```

Leave `client_secret` and `admin_ssh_public_key` unset (or `null`) in `terraform.tfvars`; Terraform now pulls both values directly from the referenced Key Vault secrets unless you explicitly override them.

Terraform loads `client_secret` and `admin_ssh_public_key` from the Key Vault data sources defined in `envs/<env>/secrets.tf`. Inline values in `terraform.tfvars` still override the vault if you supply them, which can help with rotations or break-glass overrides. After the vault is seeded you can delete any lingering plaintext secrets from version control.

Because those data sources authenticate through the Azure CLI (`use_cli = true` on the bootstrap provider), run `az login` (or ensure your CI job provides an Azure CLI context) before `terraform init/plan/apply` so Terraform can read the secrets needed to configure the service principal provider.

## Running an Environment

1. **Authenticate**: ensure the Terraform service principal has at least `Contributor` plus `User Access Administrator` on the target resource group so it can create role assignments and policy objects.
2. **Set variables**: edit `envs/<env>/terraform.tfvars` with subscription IDs, SP IDs, Key Vault references, region, tags, networking ranges, VM settings, and policy defaults. Secrets themselves live in Key Vault.
3. **Init**:
   ```bash
   cd envs/dev   # or envs/prod
   terraform init
   ```
4. **Plan / apply**:
   ```bash
   terraform plan  -var-file=terraform.tfvars
   terraform apply -var-file=terraform.tfvars
   ```
5. **Destroy** (per environment):
   ```bash
   terraform destroy -var-file=terraform.tfvars
   ```

Terraform only manages the resources declared inside that environment’s directory. Destroying `envs/dev` has no effect on `envs/prod` because the states are isolated.

## Policy Workflow

The `policy` module creates subscription-scoped policy definitions and bundles them into an initiative. A resource-group assignment with a system-assigned managed identity enforces the initiative inside the environment’s RG. The module also grants that identity `Contributor` so remediation tasks can execute. Name/ID collisions are avoided by running the policies from the appropriate environment (or by importing existing definitions before apply).

## References

- [Terraform documentation](https://www.terraform.io/docs/)
- [AzureRM provider docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
