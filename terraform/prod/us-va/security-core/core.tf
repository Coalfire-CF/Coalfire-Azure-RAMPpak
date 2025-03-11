module "core" {
  source = "github.com/Coalfire-CF/ACE-Azure-SecurityCore?ref=v1.0.2"

  subscription_id         = var.subscription_id
  resource_prefix         = local.resource_prefix
  location_abbreviation   = var.location_abbreviation
  location                = var.location
  app_abbreviation        = var.app_abbreviation
  tenant_id               = var.tenant_id
  regional_tags           = var.regional_tags
  global_tags             = merge(var.global_tags, local.global_local_tags)
  core_rg_name            = "${local.resource_prefix}-core-rg"
  cidrs_for_remote_access = var.cidrs_for_remote_access
  admin_principal_ids     = var.admin_principal_ids
  app_subscription_ids    = var.app_subscription_ids
  enable_sub_logs         = false
  enable_aad_logs         = false
  enable_aad_permissions  = false
  azure_private_dns_zones = [
    "privatelink.azurecr.us",
    "privatelink.database.usgovcloudapi.net",
    "privatelink.blob.core.usgovcloudapi.net",
    "privatelink.table.core.usgovcloudapi.net",
    "privatelink.queue.core.usgovcloudapi.net",
    "privatelink.file.core.usgovcloudapi.net",
    "privatelink.postgres.database.usgovcloudapi.net"
  ]
}
