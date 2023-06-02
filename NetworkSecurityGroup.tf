# In Azure, a Network Security Group (NSG) is a security feature that controls inbound and outbound traffic to Azure resources. 
# An NSG is a set of rules that allow or deny traffic based on criteria such as source IP address, destination IP address, port number, and protocol. 
# NSGs can be applied to subnets, individual virtual machines, or network interfaces.

# Using Terraform, you can create and manage NSGs for your Azure resources using the azurerm_network_security_group resource. The azurerm_network_security_group resource allows you to specify the following attributes:
# -> name: The name of the NSG.
# -> location: The location of the NSG.
# -> resource_group_name: The name of the resource group in which to create the NSG.
# -> security_rule: A set of security rules that define the traffic that is allowed or denied.

# Provider configuration
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
}

# Network Security Group
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPSInbound"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
  }
}

# This code creates an NSG in a resource group with two security rules allowing inbound traffic on ports 80 and 443. 
# The NSG also has a tag for identifying the environment.
# Note that this code is just an example and may need to be modified to suit your specific requirements. 
# Additionally, you will need to authenticate with Azure and configure the azurerm provider before running this code.