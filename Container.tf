# In Terraform, a storage container is a logical container for storing data objects in Azure Blob storage. 
# Containers provide a way to organize your data objects, similar to the way folders organize files on a file system.

# The azurerm_storage_container resource is defined in the Terraform AzureRM provider and allows you to specify the following attributes:
# -> name: The name of the storage container.
# -> storage_account_name: The name of the storage account in which to create the container.
# -> resource_group_name: The name of the resource group in which to create the container.
# -> container_access_type: The access level for the container, which can be either private or blob.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "eastus"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorage"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "example" {
  name                  = "example-container"
  resource_group_name   = azurerm_resource_group.example.name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

# In this example, we first create an Azure resource group using the azurerm_resource_group resource. 
# We specify the name and location of the resource group.
# Next, we create an Azure Storage account using the azurerm_storage_account resource. 
# We specify the name, resource group, location, account tier, replication type, and tags.
# Finally, we create an Azure Storage container using the azurerm_storage_container resource. 
# We specify the name, resource group, storage account, and access type for the container. 
# In this case, the access type is set to private, which means that the container can only be accessed by authorized users.
# Once you have created the Terraform configuration file with the above code, you can run terraform init to initialize the working directory, terraform plan to preview the changes, and terraform apply to create the resources in Azure. 
# The container will be created in the specified storage account.