output "web_nsg_id" {
  value = module.web-nsg.network_security_group_id
}

output "use2_web1_ip" {
  value = module.web1.network_interface_private_ip
}

output "use2_web2_ip" {
  value = module.web2.network_interface_private_ip
}

output "use2_web3_ip" {
  value = module.web2.network_interface_private_ip
}

output "use2_web4_ip" {
  value = module.web2.network_interface_private_ip
}

output "use2_web1_id" {
  value = module.web1.vm_id
}

output "use2_web2_id" {
  value = module.web2.vm_id
}

output "use2_web3_id" {
  value = module.web3.vm_id
}

output "use2_web4_id" {
  value = module.web4.vm_id
}
