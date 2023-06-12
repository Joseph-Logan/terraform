# Create name of mssql server
resource "random_pet" "azurerm_mssql_server_name" {
  prefix = "sql-octopus"
  length = 1
}

# Generate random pws for db
resource "random_password" "admin_password" {
  count       = var.admin_password == null ? 1 : 0
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

locals {
  admin_password = try(random_password.admin_password[0].result, var.admin_password)
}

# Create mssql server
resource "azurerm_mssql_server" "server" {
  name                         = random_pet.azurerm_mssql_server_name.id
  resource_group_name          = var.resource_vm_group_name
  location                     = var.resource_group_location
  administrator_login          = var.admin_username
  administrator_login_password = local.admin_password
  version                      = var.mssql_version
}

# Useful when the resource has already been created
data "azurerm_subnet" "local_virtual_network_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_vm_group_name
}

# Create network rule
resource "azurerm_mssql_virtual_network_rule" "mssql_net_rule" {
  name      = "sql-vnet-rule"
  server_id = azurerm_mssql_server.server.id
  subnet_id = data.azurerm_subnet.local_virtual_network_subnet.id
}

# Create mssql database
resource "azurerm_mssql_database" "db" {
  name                        = var.sql_db_name
  server_id                   = azurerm_mssql_server.server.id
  sku_name                    = "GP_S_Gen5_1"
  auto_pause_delay_in_minutes = 60
  min_capacity                = 0.5
  max_size_gb                 = 32
}

