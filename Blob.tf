# In Azure Storage, a blob is a type of data object that can store unstructured data such as text and binary data. 
# Blobs are typically used for storing large files, images, videos, and backups.

# The azurerm_storage_blob resource allows you to specify the following attributes:
# -> name: The name of the blob.
# -> storage_account_name: The name of the storage account that contains the blob.
# -> resource_group_name: The name of the resource group in which the storage account is located.
# -> container_name: The name of the container that holds the blob.
# -> type: The type of the blob, which can be either Block or Page.
# -> source: The path to the file that contains the contents of the blob.
# -> content_type: The MIME type of the blob.
# -> metadata: A map of metadata values to assign to the blob.

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "examplecontainer"
  resource_group_name   = azurerm_resource_group.example.name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

# In the above example, the azurerm_resource_group resource creates a new resource group in the "eastus" location. 
# The azurerm_storage_account resource creates a new Blob Storage account in the same location and resource group. 
# The account_tier parameter specifies the performance tier of the account, and the account_replication_type parameter specifies the type of replication used for data durability.
# The azurerm_storage_container resource creates a new container within the Blob Storage account, with the name parameter specifying the name of the container.
# The container_access_type parameter specifies the level of public access to the container, with "private" meaning that the container is not accessible publicly.
# You can then upload files to the container using the Azure CLI or another tool, or you can use the azurerm_storage_blob resource in Terraform to create and manage blobs within the container.