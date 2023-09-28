output "traffic_manager_id" {
  value = azurerm_traffic_manager_profile.traffic_manager.id
}

output "traffic_manager_fqdn" {
  value = azurerm_traffic_manager_profile.traffic_manager.fqdn
}
