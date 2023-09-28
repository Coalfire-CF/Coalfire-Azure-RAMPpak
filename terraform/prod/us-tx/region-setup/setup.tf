module "setup" {
  source = "../../../modules/coalfire-secondary-region-setup"

  location              = var.location
  app_abbreviation      = var.app_abbreviation
  location_abbreviation = var.location_abbreviation
  regional_tags         = var.regional_tags
  global_tags           = var.global_tags
  mgmt_rg_name          = "${var.location_abbreviation}-mp-${var.app_abbreviation}-management-rg"
  app_rg_name           = "${var.location_abbreviation}-mp-${var.app_abbreviation}-application-rg"
  key_vault_rg_name     = "${var.location_abbreviation}-mp-${var.app_abbreviation}-keyvault-rg"
  networking_rg_name    = "${var.location_abbreviation}-mp-${var.app_abbreviation}-networking-rg"

  sas_start_date = "2021-03-14"
  sas_end_date   = "2021-09-15"
}
