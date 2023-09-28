output "ussc_app_gateway_ip_id" {
  value = azurerm_public_ip.ussc-appgw-pip.id
}

output "ussc_app_gateway_ip" {
  value = azurerm_public_ip.ussc-appgw-pip.ip_address
}
