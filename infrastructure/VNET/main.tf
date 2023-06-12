# Create resource name
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_vm_group_name
}

# Create virtual network
resource "azurerm_virtual_network" "local_virtual_network" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "local_virtual_network_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.local_virtual_network.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}