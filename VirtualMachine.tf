# In Azure, a virtual machine (VM) is a virtualized computing environment that runs an operating system and applications like a physical computer. 
# Azure VMs can be used to run a variety of workloads such as web applications, databases, and custom software.

# Using Terraform, you can create and manage Azure virtual machines using the azurerm_virtual_machine resource. 
# The azurerm_virtual_machine resource allows you to specify the following attributes:
# -> name: The name of the virtual machine.
# -> location: The location of the virtual machine.
# -> resource_group_name: The name of the resource group in which to create the virtual machine.
# -> network_interface_ids: A list of network interface IDs to associate with the virtual machine.
# -> vm_size: The size of the virtual machine.
# -> storage_image_reference: The reference to the operating system image to use for the virtual machine.
# -> storage_os_disk: The configuration of the virtual machine's operating system disk.
# -> os_profile: The configuration of the virtual machine's operating system profile.
# -> os_profile_windows_config (for Windows VMs): The configuration of the virtual machine's operating system profile for Windows VMs.
# -> os_profile_linux_config (for Linux VMs): The configuration of the virtual machine's operating system profile for Linux VMs.
# -> boot_diagnostics: The configuration of the virtual machine's boot diagnostics.

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
}

# Subnet
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "example-ip-config"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual machine
resource "azurerm_virtual_machine" "example" {
  name                  = "example-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_B2s"
  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "example-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "example-vm"
    admin_username = "adminuser"
    admin_password = "StrongPassword1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# This code creates a VM in a resource group with a virtual network, subnet, network interface, and associated resources. 
# The VM uses an Ubuntu Server 18.04-LTS image and has a managed OS disk of the Standard_LRS type. 
# The VM also has an OS profile with an admin username and password, and allows password authentication for SSH. 
# Note that this code is just an example and may need to be modified to suit your specific requirements. 
# Additionally, you will need to authenticate with Azure and configure the azurerm provider before running this code.