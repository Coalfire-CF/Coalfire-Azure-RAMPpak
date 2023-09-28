module "aks" {
  source                = "github.com/Coalfire-CF/ACE-Azure-AKS"
  name                  = "mgmt-demo-us-aks"
  resource_group_name   = "df-prod-va-mp-management-rg"
  location              = var.location
  subnet_id             = "/subscriptions/c14355b2-e625-4197-9538-b3e72fe41801/resourceGroups/df-prod-va-mp-networking-rg/providers/Microsoft.Network/virtualNetworks/df-prod-va-mp-network-vnet/subnets/df-prod-va-mp-cicd-sn-1"
  diag_log_analytics_id = data.terraform_remote_state.core.outputs.core_la_id
  key_vault_id          = "/subscriptions/c14355b2-e625-4197-9538-b3e72fe41801/resourceGroups/df-prod-va-mp-core-rg/providers/Microsoft.KeyVault/vaults/df-prod-va-mp-core-kv-46"
  #private_dns_zone_id   = data.terraform_remote_state.core.outputs.core_private_dns_zone_id.1
  private_dns_zone_id = "/subscriptions/c14355b2-e625-4197-9538-b3e72fe41801/resourceGroups/df-prod-va-mp-core-rg/providers/Microsoft.Network/privateDnsZones/privatelink.usgovvirginia.cx.aks.containerservice.azure.us"
  enable_fips         = true

  tags = {
    Plane       = "Management"
    Environment = "dev"
  }

  # User Defined Node Pools
  user_node_pools = [
    {
      name            = "dev"
      vm_size         = "Standard_D2_v4"
      os_disk_size_gb = 100
      max_count       = 2
      min_count       = 1
    }
  ]
}
