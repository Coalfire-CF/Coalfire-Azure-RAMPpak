module "setup" {
  source = "github.com/Coalfire-CF/ACE-Azure-RegionSetup?ref=v1.0.6"

  location_abbreviation = var.location_abbreviation
  location              = var.location
  resource_prefix       = local.resource_prefix
  app_abbreviation      = var.app_abbreviation
  regional_tags         = var.regional_tags
  global_tags           = merge(var.global_tags, local.global_local_tags)
  mgmt_rg_name          = "${local.resource_prefix}-management-rg"
  app_rg_name           = "${local.resource_prefix}-application-rg"
  key_vault_rg_name     = "${local.resource_prefix}-keyvault-rg"
  networking_rg_name    = "${local.resource_prefix}-networking-rg"
  sas_start_date        = "2025-03-11" # Today's date
  sas_end_date          = "2025-06-11" # 3 months from today
  ip_for_remote_access  = var.ip_for_remote_access
  core_kv_id            = data.terraform_remote_state.core.outputs.core_kv_id
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id

  # uncomment the following line when the mgmt-network is created
  #firewall_vnet_subnet_ids = values(data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_vnet_subnet_ids) #Uncomment and rerun terraform apply after the mgmt-network is created

  additional_resource_groups = [
    "${local.resource_prefix}-identity-rg"
  ]

  # (Optional) Resource Names
  # Uncomment to define custom resource names, if required
  # compute_gallery_name           = ""
  # cloudshell_storageaccount_name = ""
  # ars_storageaccount_name        = ""
  # docs_storageaccount_name       = ""
  # flowlogs_storageaccount_name   = ""
  # installs_storageaccount_name   = ""
  # vmdiag_storageaccount_name     = ""
  # network_watcher_name           = ""

  # (Optional) File Uploads
  # Uncomment to define paths to files which will be uploaded to the installs storage account
  # file_upload_paths = [
  #   "../../../../path/to/file",
  #   "../../../../path/to/another-file"
  # ]

  # (Optional) VM image definitions 
  # Uncomment to bootstrap Image Definitions in the Azure Compute Gallery
  # vm_image_definitions = [
  #   {
  #     name                 = "rhel-8-10-golden-stig"
  #     os_type              = "Linux"
  #     identifier_publisher = "rhel"
  #     identifier_offer     = "LinuxServer"
  #     identifier_sku       = "RHEL8-10"
  #   },
  #   {
  #     name                 = "win-server2022-golden"
  #     os_type              = "Windows"
  #     identifier_publisher = "microsoft"
  #     identifier_offer     = "WindowsServer"
  #     identifier_sku       = "2022-datacenter-g2"
  #   }
  # ]
}
