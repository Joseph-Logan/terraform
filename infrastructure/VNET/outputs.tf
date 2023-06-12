output "local_virtual_network_id" {
  value = azurerm_virtual_network.local_virtual_network.id
}

output "local_virtual_network_subnet_id" {
  value = azurerm_subnet.local_virtual_network_subnet.id
}