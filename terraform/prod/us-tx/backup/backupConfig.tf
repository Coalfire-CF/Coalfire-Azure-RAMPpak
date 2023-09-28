resource "azurerm_recovery_services_vault" "ars_vault" {
  name                = "${var.location_abbreviation}-mp-${var.app_abbreviation}-ars-vault"
  location            = var.location
  resource_group_name = data.terraform_remote_state.ussc-setup.outputs.management_rg_name
  sku                 = "Standard"
}
