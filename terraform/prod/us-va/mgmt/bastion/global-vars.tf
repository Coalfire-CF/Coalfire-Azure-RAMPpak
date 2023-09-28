#TODO: review and change all vars below as necessary
# VARIABLES
variable "subscription_id" {
  type    = string
  default = "ddd2f101-5edd-4a16-a7aa-33799c9b5bc8" # Mark43 Staging Subscription
}

variable "tenant_id" {
  type    = string
  default = "59e07c50-64a1-4638-975b-0aae7c46b402" # Mark43 Staging Tenant
}

variable "app_subscription_ids" {
  type = map(any)
  default = {
    staging = "ddd2f101-5edd-4a16-a7aa-33799c9b5bc8"
  }
}

variable "app_abbreviation" {
  description = "A abbreviation that should be attached to the names of resources"
  type        = string
  default     = "m43gov" #Mark43-gov
}

variable "global_tags" {
  type = map(string)
  default = {
    Managed_By = "Terraform"
  }
}

variable "cidrs_for_remote_access" {
  type        = list(any)
  description = "List of IPv4 CIDR ranges to access all admins remote access"
  default = [
    "209.236.109.246/32", # Coalfire VPN
    "63.235.52.58/32",    # Reston office
    "207.179.214.235/32", # Douglas
    "71.237.93.74/32",    # Keegan
    "23.125.203.160/32",  # Thomas
    "47.188.40.163/32",   # Jonathan
    "199.127.201.66/32",  # Westminster office
    "70.130.190.247/32",  # James
    "108.56.232.101/32",  # Max?
    "96.35.33.118/32",    # Kourosh Mobl
    "192.34.162.165/32",  # Brandon Donahoo
    "108.17.74.91/32",    # Scott Moskal
    "96.35.55.200/32",    # Kourosh?
    "131.226.32.146/32",  #Mark43 IPs
    "15.205.239.40/32",   #Mark43 IPs
    "52.61.189.82/32",    #Mark43 IPs
    "3.30.99.89/32"       #Mark43 IPs
  ]
}

variable "ip_for_remote_access" {
  type        = list(any)
  description = "This is the same as 'cidrs_for_remote_access' but without the /32 on each of the files. The 'ip_rules' in the storage account will not accept a '/32' address and I gave up trying to strip and convert the values over"

  default = [
    "209.236.109.246", # Coalfire VPN
    "63.235.52.58",    # Reston Office
    "207.179.214.235", # Douglas
    "192.81.44.12",    # ???
    "71.237.93.74",    # Keegan
    "23.125.203.160",  # Thomas
    "47.188.40.163",   # Jonathan
    "199.127.201.66",  # Westminster office
    "70.130.190.247",  # James
    "108.56.232.101",  # Max?
    "96.35.33.118",    # Kourosh Mobl
    "192.34.162.165",  # Brandon Donahoo
    "108.17.74.91",    # Scott Moskal
    "96.35.55.200",    # Kourosh?
    "131.226.32.146",  #Mark43 IPs
    "15.205.239.40",   #Mark43 IPs
    "52.61.189.82",    #Mark43 IPs
    "3.30.99.89"       #Mark43 IPs
  ]
}

variable "admin_principal_ids" {
  type        = set(string)
  description = "List of principal ID's for all admins"
  default = [
    "38f012e6-6743-4c80-ba35-cc34d06195f6", # Kourosh Mobl
    "88e420d1-ef38-46ab-ab9b-241df1af9e1d", # Brandon Donahoo
    "8806f36e-abe8-42a4-957c-85fc11c6d064", # Scott Moskal
    "2c16a8ea-b3a7-4a2e-b3a4-8e4ccb687c2a", # Max Salviejo
    "d22fbbb9-e161-495d-a174-25c8cfe5c64c", # Andrew Gershman
    "f69cca6d-5205-4625-803a-693160931160", # Austin Porter
    "1b9bdf7c-cf17-42a5-9a32-be2566435128", # Brian DaSilva
    "ed795cdb-a539-4644-8b56-c9d2474bcc0f", # Colby LeClerc
    "87eedd89-6111-448d-bcf8-1b7797b30556", # Connor Grady
    "9f36dcde-fc69-481d-95c4-5c67189d219b", # Jordan Diederich
    "99fe1751-e19d-4e6e-8508-381943091fc2", # Mat Sylvia
    "fb169171-7b26-4af5-8105-66ea6aee6de5", # Mike Misiaczek
    "dbfa3093-226d-472e-a868-ecbf2375027f"  # Ryan Macdonald
  ]
}

variable "vm_admin_username" {
  type        = string
  description = "Local User Name for Virtual Machines"
  default     = "xadm"
}

variable "azure_cloud" {
  type        = string
  description = "Azure Cloud (Commercial - AzureCloud/Government - AzureUSGovernment)"
  default     = "AzureUSGovernment"
}
