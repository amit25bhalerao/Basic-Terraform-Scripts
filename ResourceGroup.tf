# In Terraform, a resource group is a logical container for resources that share the same lifecycle, permissions, and policies.
# A resource group helps to organize and manage resources in a more efficient way. 

# In Terraform, a resource group is represented by the azurerm_resource_group resource.

# Provider configuration
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
  tags = {
    environment = "production"
  }
}

# This code creates a resource group with the name "example-resource-group" in the East US region. 
# The resource group also has a tag for identifying the environment.
# Note that this code is just an example and may need to be modified to suit your specific requirements. 
# Additionally, you will need to authenticate with Azure and configure the azurerm provider before running this code.