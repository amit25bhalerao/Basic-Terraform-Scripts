# Azure Load Balancer is a high-availability, scalable load balancing solution for your applications running on Azure. 
# It distributes incoming traffic across multiple virtual machines, allowing you to increase application availability and scale your applications horizontally.
# Azure Load Balancer can operate at both the Transport Layer (Layer 4) and Application Layer (Layer 7) to provide maximum flexibility for your application. 
# It supports a range of protocols, including TCP, UDP, HTTP, HTTPS, and more.
# There are two types of Azure Load Balancer: Basic and Standard. 
# Basic Load Balancer is a low-cost solution for simple applications, while Standard Load Balancer provides additional features such as health probes, session persistence, and cross-zone load balancing.

resource "azurerm_lb" "example" {
  name                = "example-lb"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                          = "example-lb-ipconfig"
    public_ip_address_id          = azurerm_public_ip.example.id
    private_ip_address_allocation = "Dynamic"
  }

  backend_address_pool {
    name = "example-backend-pool"
  }

  probe {
    name                = "example-health-probe"
    protocol            = "Http"
    port                = 80
    request_path        = "/"
    interval_in_seconds = 5
    number_of_probes    = 2
  }
}

resource "azurerm_public_ip" "example" {
  name                = "example-lb-public-ip"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
}

# In this example, we define an Azure Load Balancer named "example-lb" that is deployed to the East US region. 
# We also define a public IP address for the load balancer, a backend pool named "example-backend-pool," and a health probe named "example-health-probe." 
# The load balancer is configured to listen on port 80 and route traffic to the backend pool based on the health of the virtual machines in the pool.
# Once you have defined your Terraform configuration file, you can run the terraform apply command to deploy the Azure Load Balancer to your Azure environment. 
# You can also modify the configuration file to add additional backend pools, rules, or probes as needed.