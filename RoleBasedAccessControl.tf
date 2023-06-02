# Azure Role-Based Access Control (RBAC) is a feature in Azure that allows you to manage access to Azure resources based on the roles assigned to users or groups. 
# With RBAC, you can grant specific permissions to users or groups to perform certain actions on Azure resources. 
# This helps you to control who has access to your resources and what they can do with them.
# In Azure, you can use Terraform to automate the creation and management of RBAC roles and assignments.
# Terraform provides an AzureRM provider that allows you to create and manage Azure resources.
# You can define the configuration of your RBAC roles and assignments in a Terraform configuration file, specifying the roles, users, and permissions. 
# Once you have defined your configuration, you can use the Terraform command-line interface (CLI) to apply the changes and create the RBAC roles and assignments.

provider "azurerm" {
  features {}
}

resource "azurerm_role_definition" "example" {
  name        = "example-role"
  description = "Example role description."
  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/restart/action",
      "Microsoft.Compute/virtualMachines/powerOff/action",
    ]
    not_actions = []
  }
  assignable_scopes = [
    "/subscriptions/subscription-id",
  ]
}

resource "azurerm_role_assignment" "example" {
  name                = "example-role-assignment"
  role_definition_id  = azurerm_role_definition.example.id
  principal_id        = "user-object-id"
  scope               = "/subscriptions/subscription-id/resourceGroups/example-resource-group"
}

# In this example, the configuration file defines an RBAC role with permissions to start, restart, and power off virtual machines, and assigns the role to a user with the specified object ID. 
# The role is scoped to a specific resource group in the subscription.