# Azure Application Gateway is a Layer 7 load balancer that helps to manage traffic to web applications. 
# It provides advanced load balancing capabilities and enables features like SSL offloading, URL-based routing, and session affinity. 
# Terraform is an open-source infrastructure as code (IaC) tool that allows you to define and manage your infrastructure in a declarative way.
# Using Terraform, you can automate the deployment and configuration of Azure Application Gateway, allowing you to easily manage and scale your load balancing infrastructure. 
# Terraform provides a simple and repeatable way to create, modify, and delete resources, making it an ideal tool for managing complex infrastructure.
# To deploy an Azure Application Gateway using Terraform, you can use the AzureRM provider, which allows you to create and manage Azure resources.
# You can define the configuration of your Application Gateway in a Terraform configuration file, specifying the frontend IP configuration, backend pool, listeners, and other settings. 
# Once you have defined your configuration, you can use the Terraform command-line interface (CLI) to apply the changes and create the Application Gateway.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "westus"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "example-pip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "example" {
  name                = "example-appgw"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "example-gw-ip"
    subnet_id = azurerm_subnet.example.id
  }

  frontend_port {
    name = "example-frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "example-frontend-ip"
    public_ip_address_id = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = "example-backend-pool"
    backend_address {
      ip_address = "10.0.1.4"
    }
  }

  http_listener {
    name                           = "example-http-listener"
    frontend_ip_configuration_name = azurerm_application_gateway.example.frontend_ip_configuration[0].name
    frontend_port_name             = azurerm_application_gateway.example.frontend_port[0].name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "example-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = azurerm_application_gateway.example.http_listener[0].name
    backend_address_pool_name  = azurerm_application_gateway.example.backend_address_pool[0].name
    backend_http_settings_name = "example-http-settings"
  }

  backend_http_settings {
    name                  = "example-http-settings"
    cookie_based_affinity = "Enabled"
    port                  = 80
    protocol              = "Http"
  }
}

# This Terraform configuration creates an Azure Resource Group, Virtual Network, Subnet, Public IP Address, and an Application Gateway. 
# The Application Gateway is configured with a WAF_v2 SKU with two instances, and it has a frontend IP configuration with a public IP address and a frontend port listening on port 80. 
# It also has a backend address pool with an IP address of 10.0.1.4, and a request routing rule that forwards traffic from the frontend to the backend. 
# Finally, the backend HTTP settings are configured with cookie-based affinity, port 80, and HTTP protocol.