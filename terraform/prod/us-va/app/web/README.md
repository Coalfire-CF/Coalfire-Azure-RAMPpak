# Application Web Server Deployment

Depends on

- Region Setup
- Application VNet

## tstate.tf changes

Ensure these values are correct

- resource group
- storage account
- storage container
- unique key

## web.tf

## remote-data.tf

add/uncomment out resource block  after ```terraform apply```

re-run ```terraform apply```

## Next steps

Deploy SQL/app gateway/traffic manager

## Outputs

| Name | Description |
|------|-------------|
| web_nsg_id | Network Security Group for Web servers |
| use2_web1_ip | Web1 private IP |
| use2_web2_ip | Web2 private IP |
| use2_web3_ip | Web3 private IP |
| use2_web4_ip | Web4 private IP |
| use2_web1_id | Web1 VM ID |
| use2_web2_id | Web2 VM ID |
| use2_web3_id | Web3 VM ID |
| use2_web4_id | Web4 VM ID |
