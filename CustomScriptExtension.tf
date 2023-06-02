# In Azure, the Custom Script Extension is a virtual machine extension that enables you to run custom scripts on a virtual machine after it has been deployed. 
# The Custom Script Extension can be used to perform various tasks, such as installing software, configuring settings, or running custom commands. 
# The extension can run scripts that are stored locally on the virtual machine, or scripts that are hosted in Azure storage.

# Using Terraform, you can create and manage the Custom Script Extension for an Azure virtual machine using the azurerm_virtual_machine_extension resource. The azurerm_virtual_machine_extension resource allows you to specify the following attributes:
# -> name: The name of the extension.
# -> location: The location of the extension.
# -> resource_group_name: The name of the resource group in which to create the extension.
# -> virtual_machine_name: The name of the virtual machine to which to apply the extension.
# -> publisher: The publisher of the extension.
# -> type: The type of the extension.
# -> type_handler_version: The version of the extension.
# -> auto_upgrade_minor_version: Whether to automatically upgrade to the latest minor version of the extension.
# -> settings: The settings to pass to the extension.
# -> protected_settings: The protected settings to pass to the extension.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "eastus"
}

resource "azurerm_linux_virtual_machine" "example" {
  name                  = "example-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  size                  = "Standard_B2s"
  admin_username        = "adminuser"
  disable_password_auth = true

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    name              = "example-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "examplevm"
    admin_username = "adminuser"

    custom_data = data.template_cloudinit_config.example.rendered
  }
}

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

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

data "template_cloudinit_config" "example" {
  gzip = true

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      echo "Hello World" >> /tmp/helloworld.txt
    EOF
  }
}

resource "azurerm_virtual_machine_extension" "example" {
  name                 = "custom-script"
  virtual_machine_id   = azurerm_linux_virtual_machine.example.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    commandToExecute = "bash /tmp/helloworld.txt"
  })

  protected_settings = jsonencode({
    fileUris = []
  })
}

# In this example, we first create an Azure resource group using the azurerm_resource_group resource. 
# We specify the name and location of the resource group.
# Next, we create an Azure virtual network, subnet, network interface, and Linux virtual machine using the azurerm_virtual_network, azurerm_subnet, azurerm_network_interface, and azurerm_linux_virtual_machine resources, respectively. 
# We specify the name, location, resource group, size, admin username, and source image for the virtual machine. 
# We also specify the name, location, and address prefixes for the virtual network and subnet.
# After creating the virtual machine, we use the data.template_cloudinit_config data source to create a cloud-init script. 
# This script simply appends "Hello World" to a file named /tmp/helloworld.txt.
# Finally, we use the azurerm_virtual_machine_extension resource to add a custom script extension to the virtual machine. 
# We specify the name, virtual machine ID, publisher, type, and type handler version for the extension. 
# We also specify the command to execute (bash /tmp/helloworld.txt) in the settings block and an empty array of file URIs in the protected_settings block.
# When we apply this Terraform configuration, Terraform will create the Azure resources and add the custom script extension to the virtual machine. 
# When we connect to the virtual machine, we should see a file named /tmp/helloworld.txt with the text "Hello World" appended to it.