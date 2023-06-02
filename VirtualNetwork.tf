# In Azure, a virtual network (VNet) is a logically isolated network that you can use to deploy your Azure resources. 
# VNets allow you to create your own private IP address space, define subnets, and configure routing tables, network security groups (NSGs), and other networking features.

# Using Terraform, you can create and manage Azure virtual networks using the azurerm_virtual_network resource. 
# The azurerm_virtual_network resource allows you to specify the following attributes:
# -> name: The name of the virtual network.
# -> address_space: The address space for the virtual network in CIDR notation.
# -> location: The location of the virtual network.
# -> resource_group_name: The name of the resource group in which to create the virtual network.
# -> dns_servers: The DNS servers to use for the virtual network.
# -> subnets: A list of subnets to create within the virtual network.

# Provider configuration
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
}

# Virtual network
resource "azurerm_virtual_network" "example" {
  name                = "example-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  subnet {
    name           = "example-subnet"
    address_prefix = "10.0.1.0/24"
  }
}

# Network security group
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Subnet network security group association
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_virtual_network.example.subnet.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# This code creates a virtual network in a resource group with a single subnet and a network security group. 
# The subnet is associated with the network security group using the azurerm_subnet_network_security_group_association resource. 
# In this example, the network security group allows inbound SSH traffic.
# Note that this code is just an example and may need to be modified to suit your specific requirements. 
# Additionally, you will need to authenticate with Azure and configure the azurerm provider before running this code.