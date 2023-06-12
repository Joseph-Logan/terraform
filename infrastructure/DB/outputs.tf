output "sql_server_name" {
  value = azurerm_mssql_server.server.name
}

output "sql_server_domain_name" {
  value = azurerm_mssql_server.server.fully_qualified_domain_name
}

output "sql_db_name" {
  value = azurerm_mssql_database.db.name
}

output "admin_username" {
  value = azurerm_mssql_server.server.administrator_login
}

output "admin_password" {
  sensitive = true
  value     = local.admin_password
}