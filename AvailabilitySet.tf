# In Azure, an availability set is a logical grouping of two or more virtual machines that are deployed across different physical hardware in a data center. 
# By deploying virtual machines in an availability set, you can improve the availability and reliability of your applications by ensuring that they are not all impacted by a single point of failure, such as a power outage or a hardware failure.

# Using Terraform, you can create and manage Azure availability sets using the azurerm_availability_set resource. 
# The azurerm_availability_set resource allows you to specify the following attributes:
# -> name: The name of the availability set.
# -> location: The location of the availability set.
# -> resource_group_name: The name of the resource group in which to create the availability set.
# -> platform_update_domain_count: The number of update domains for the availability set.
# -> platform_fault_domain_count: The number of fault domains for the availability set.
# -> managed: Whether the availability set is managed or unmanaged.

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
}

resource "azurerm_availability_set" "example" {
  name                = "example-availability-set"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  platform_fault_domain_count = 2
  platform_update_domain_count = 5
}

# In the above example, the azurerm_resource_group resource creates a new resource group in the "eastus" location. 
# The azurerm_availability_set resource creates a new Availability Set in the same location and resource group. 
# The platform_fault_domain_count and platform_update_domain_count parameters define the number of fault and update domains for the Availability Set.
# You can customize the Availability Set further by adding virtual machines to it using the availability_set_id parameter in the azurerm_virtual_machine resource.
# You can also specify load balancers, virtual machine scale sets, and other resources to use the Availability Set for fault tolerance and high availability.