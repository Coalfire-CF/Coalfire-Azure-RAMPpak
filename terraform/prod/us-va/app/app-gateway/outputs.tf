output "use2_app_gateway_ip_id" {
  value = azurerm_public_ip.use2-appgw-pip.id
}

output "use2_app_gateway_ip" {
  value = azurerm_public_ip.use2-appgw-pip.ip_address
}
