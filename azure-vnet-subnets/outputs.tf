output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  description = "Address space of the Virtual Network"
  value       = azurerm_virtual_network.main.address_space
}

output "inside_subnet_name" {
  description = "Name of the inside subnet"
  value       = azurerm_subnet.inside.name
}

output "inside_subnet_prefix" {
  description = "Address prefix of the inside subnet"
  value       = azurerm_subnet.inside.address_prefixes
}

output "outside_subnet_name" {
  description = "Name of the outside subnet"
  value       = azurerm_subnet.outside.name
}

output "outside_subnet_prefix" {
  description = "Address prefix of the outside subnet"
  value       = azurerm_subnet.outside.address_prefixes
}

output "network_security_group_id" {
  description = "ID of the Network Security Group"
  value       = azurerm_network_security_group.nsg.id
}
