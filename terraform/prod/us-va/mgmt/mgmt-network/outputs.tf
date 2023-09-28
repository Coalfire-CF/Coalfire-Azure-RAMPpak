output "usgv_mgmt_vnet_id" {
  value = module.mgmt-vnet.vnet_id
}

output "usgv_mgmt_vnet_name" {
  value = module.mgmt-vnet.vnet_name
}

output "usgv_mgmt_vnet_subnet_ids" {
  value = module.mgmt-vnet.vnet_subnets
}

output "usgv_mgmt_networks" {
  value = module.mgmt-vnet.subnet_addresses
}


# output "network_cidr_blocks" {
#   value = module.subnet_addrs.network_cidr_blocks
# }

output "networks" {
  value = module.subnet_addrs.networks
}
