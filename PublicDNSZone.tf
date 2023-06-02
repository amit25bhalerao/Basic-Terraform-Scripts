# Azure Public DNS Zone is a service provided by Microsoft Azure that allows you to host your DNS domain in Azure's globally distributed DNS infrastructure. 
# With Azure Public DNS Zone, you can manage your DNS records using the Azure Portal, Azure CLI, or Azure PowerShell.
# To create an Azure Public DNS Zone using Terraform, you need to define the following resources:
# -> Resource Group: A logical container for resources in Azure.
# -> DNS Zone: The actual DNS Zone that will be created in Azure.
# -> DNS Record: The DNS record that will be associated with the DNS Zone.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "dns" {
  name     = "dns-resource-group"
  location = "eastus"
}

resource "azurerm_dns_zone" "example" {
  name                = "example.com"
  resource_group_name = azurerm_resource_group.dns.name
}

resource "azurerm_dns_a_record" "example" {
  name                = "www"
  zone_name           = azurerm_dns_zone.example.name
  resource_group_name = azurerm_resource_group.dns.name
  ttl                 = 300
  records             = ["10.0.0.1"]
}

# In this example, a new resource group is created in the East US region, and an Azure Public DNS Zone named "example.com" is created within that resource group. 
# A new A record is also created for the "www" subdomain, pointing to the IP address "10.0.0.1".
# You can use the terraform apply command to create these resources in Azure.