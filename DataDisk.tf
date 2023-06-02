# In Azure, a data disk is a virtual hard disk that you can attach to a virtual machine. 
# Data disks can be used to store data that is not part of the operating system, such as databases or large files. You can attach one or more data disks to a virtual machine, depending on your needs.

# Using Terraform, you can create and manage Azure data disks using the azurerm_managed_disk resource. 
# The azurerm_managed_disk resource allows you to specify the following attributes:
# -> name: The name of the data disk.
# -> location: The location of the data disk.
# -> resource_group_name: The name of the resource group in which to create the data disk.
# -> storage_account_type: The storage account type for the data disk (either "Standard_LRS", "Premium_LRS", or "StandardSSD_LRS").
# -> create_option: The method used to create the data disk (either "Empty" or "Copy").
# -> disk_size_gb: The size of the data disk (in GB).
# -> source_uri: The URI of the source data disk to use if create_option is set to "Copy".
# -> disk_iops_read_write: The number of IOPS (input/output operations per second) that the data disk can support.
# -> disk_mbps_read_write: The number of MBps (megabytes per second) that the data disk can support.

# Provider configuration
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
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
    name              = "example-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}

# Network interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "example-ipconfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Subnet
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Virtual network
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Data disk
resource "azurerm_managed_disk" "example" {
  name                 = "example-datadisk"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 128
}

# Attach the data disk to the virtual machine
resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_virtual_machine.example.id
  lun                = 0
  caching            = "ReadWrite"
  create_option      = "Attach"
}

# This code creates an Azure virtual machine with a data disk attached to it. 
# The data disk is created as a managed disk and attached to the virtual machine using the azurerm_virtual_machine_data_disk_attachment resource. 
# The disk is 128 GB in size and uses the Standard_LRS storage account type.