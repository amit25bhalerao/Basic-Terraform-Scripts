# In Azure, a public IP address (IP) is an IP address that can be used to communicate with a virtual machine or a service from the internet. 
# Public IP addresses can be associated with Azure resources such as virtual machines, load balancers, and application gateways.

# Using Terraform, you can create and manage Azure public IP addresses using the azurerm_public_ip resource. 
# The azurerm_public_ip resource allows you to specify the following attributes:
# -> name: The name of the public IP address.
# -> location: The location of the public IP address.
# -> resource_group_name: The name of the resource group in which to create the public IP address.
# -> allocation_method: The allocation method for the public IP address (either "Static" or "Dynamic").
# -> sku: The SKU of the public IP address (either "Basic" or "Standard").
# -> ip_version: The IP version for the public IP address (either "IPv4" or "IPv6").
# -> dns_name_label: The DNS name label for the public IP address.
# -> domain_name_label: The domain name label for the public IP address (for use with Azure DNS).
# -> idle_timeout_in_minutes: The idle timeout for the public IP address (in minutes).

# Provider configuration
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
}

# Public IP address
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "example"
  tags = {
    environment = "production"
  }
}

# This code creates a public IP address in a resource group with a static allocation method and standard SKU. 
# The domain name label is set to "example" and the IP address has a tag for identifying the environment.
# Note that this code is just an example and may need to be modified to suit your specific requirements. 
# Additionally, you will need to authenticate with Azure and configure the azurerm provider before running this code.
