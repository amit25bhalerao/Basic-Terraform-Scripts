# Cloud-init is a popular tool used to customize and configure virtual machines and instances running in cloud environments such as Azure. 
# Cloud-init data is a set of user data that is passed to a virtual machine or instance during provisioning and is used to configure and customize the system.

# In Azure, cloud-init data can be passed to a virtual machine using the custom_data parameter of the azurerm_linux_virtual_machine or azurerm_windows_virtual_machine resource. 

data "template_cloudinit_config" "example" {
  gzip = true

  part {
    filename     = "example-part-1.txt"
    content_type = "text/plain"
    content      = <<-EOF
      #cloud-config
      hostname: example-vm
      ssh_authorized_keys:
        - <SSH public key>
      runcmd:
        - echo "Hello, world!" > /tmp/hello.txt
    EOF
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
}

resource "azurerm_linux_virtual_machine" "example" {
  name                  = "example-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  size                  = "Standard_DS1_v2"
  admin_username        = "adminuser"
  disable_password_auth = true
  network_interface_ids = [azurerm_network_interface.example.id]

  os_disk {
    name              = "example-os-disk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "example-vm"
    admin_username = "adminuser"
    custom_data    = data.template_cloudinit_config.example.rendered
  }
}

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

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name                 = "example-subnet"
    address_prefix       = "10.0.2.0/24"
  }
}

# The azurerm_linux_virtual_machine resource creates a new Linux virtual machine, sets the location and resource group, specifies the size of the virtual machine, and disables password authentication. 
# It also associates the network interface created earlier with the virtual machine, specifies the OS disk, and specifies the source image to use for the virtual machine. 
# The os_profile block is where we specify the cloud-init data by setting the custom_data field to the rendered output of the data.template_cloudinit_config.example resource.
# The azurerm_network_interface resource creates a new network interface for the virtual machine, sets the location and resource group, and specifies the IP configuration for the network interface.
# The azurerm_subnet resource creates a new subnet for the virtual network, sets the location and resource group, and specifies the address prefix for the subnet.
# The azurerm_virtual_network resource creates a new virtual network, sets the location and resource group, and specifies the address space for the virtual network. 
# It also creates a new subnet within the virtual network and specifies the address prefix for the subnet.
# Once you have created the Terraform configuration file with the above code, you can run terraform init to initialize the working directory, terraform plan to preview the changes, and terraform apply to create the resources in Azure. 
# The cloud-init data will be applied when the virtual machine is provisioned.