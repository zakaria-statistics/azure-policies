#############################################
# SINGLE-VERSION POLICY DESIGN
# This file BOTH:
# 1) Defines policies
# 2) Bundles them into an initiative
# 3) Assigns them to THIS lab RG
#############################################

#############################################
# Policy 1: Required tags
#############################################
resource "azurerm_policy_definition" "tags_required" {
  name         = "compute-lab-tags-required"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Compute Lab - Require standard tags"

  parameters = jsonencode({
    tag1 = { type = "String", defaultValue = "environment" }
    tag2 = { type = "String", defaultValue = "owner" }
    tag3 = { type = "String", defaultValue = "cost_center" }
    effect = {
      type          = "String"
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = var.default_effect
    }
  })

  policy_rule = jsonencode({
    if = {
      anyOf = [
        { field = "[concat('tags[', parameters('tag1'), ']')]", exists = "false" },
        { field = "[concat('tags[', parameters('tag2'), ']')]", exists = "false" },
        { field = "[concat('tags[', parameters('tag3'), ']')]", exists = "false" }
      ]
    }
    then = { effect = "[parameters('effect')]" }
  })
}

#############################################
# Policy 2: Allowed regions
#############################################
resource "azurerm_policy_definition" "allowed_regions" {
  name         = "compute-lab-allowed-regions"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Compute Lab - Allowed regions"

  parameters = jsonencode({
    listOfAllowedLocations = { type = "Array", defaultValue = var.allowed_locations }
    effect = {
      type          = "String"
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = var.default_effect
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "location", exists = "true" },
        { not = { field = "location", in = "[parameters('listOfAllowedLocations')]" } }
      ]
    }
    then = { effect = "[parameters('effect')]" }
  })
}

#############################################
# Policy 3: Allowed VM SKUs
#############################################
resource "azurerm_policy_definition" "allowed_vm_skus" {
  name         = "compute-lab-allowed-vm-skus"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Compute Lab - Allowed VM SKUs"

  parameters = jsonencode({
    allowedSkus = { type = "Array", defaultValue = var.allowed_vm_skus }
    effect = {
      type          = "String"
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = var.default_effect
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", equals = "Microsoft.Compute/virtualMachines" },
        { not = { field = "Microsoft.Compute/virtualMachines/sku.name", in = "[parameters('allowedSkus')]" } }
      ]
    }
    then = { effect = "[parameters('effect')]" }
  })
}

#############################################
# Policy 4: Managed Identity required on VM
#############################################
resource "azurerm_policy_definition" "managed_identity_required" {
  name         = "compute-lab-mi-required"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Compute Lab - Require Managed Identity"

  parameters = jsonencode({
    effect = {
      type          = "String"
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = var.default_effect
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", equals = "Microsoft.Compute/virtualMachines" },
        { field = "identity.type", exists = "false" }
      ]
    }
    then = { effect = "[parameters('effect')]" }
  })
}

#############################################
# Initiative: Compute Lab baseline
#############################################
resource "azurerm_policy_set_definition" "compute_initiative" {
  name         = "compute-lab-initiative"
  policy_type  = "Custom"
  display_name = "Compute Lab - Baseline Initiative"
  description  = "Bundles tags, regions, VM SKUs, and managed identity rules."

  parameters = jsonencode({
    effect = {
      type          = "String"
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = var.default_effect
    }
    allowedLocations = { type = "Array", defaultValue = var.allowed_locations }
    allowedVmSkus    = { type = "Array", defaultValue = var.allowed_vm_skus }
  })

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.tags_required.id
    parameter_values = jsonencode({
      effect = { value = "[parameters('effect')]" }
    })
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.allowed_regions.id
    parameter_values = jsonencode({
      listOfAllowedLocations = { value = "[parameters('allowedLocations')]" }
      effect                 = { value = "[parameters('effect')]" }
    })
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.allowed_vm_skus.id
    parameter_values = jsonencode({
      allowedSkus = { value = "[parameters('allowedVmSkus')]" }
      effect      = { value = "[parameters('effect')]" }
    })
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.managed_identity_required.id
    parameter_values = jsonencode({
      effect = { value = "[parameters('effect')]" }
    })
  }
}

#############################################
# ASSIGNMENT (this is the "turn it on" step)
# Scope = this lab RG only.
#############################################
resource "azurerm_resource_group_policy_assignment" "compute_initiative_assignment" {
  name                 = "${var.rg_name}-compute-initiative"
  display_name         = "Compute Lab - Baseline (Assigned)"
  description          = "Applies this lab's initiative to this lab RG."
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_set_definition.compute_initiative.id

  # Safe default for future remediation-type expansions.
  identity { type = "SystemAssigned" }

  location = azurerm_resource_group.rg.location
}

# Give assignment identity rights at lab scope
resource "azurerm_role_assignment" "compute_initiative_assignment_contrib" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.compute_initiative_assignment.identity[0].principal_id
}
