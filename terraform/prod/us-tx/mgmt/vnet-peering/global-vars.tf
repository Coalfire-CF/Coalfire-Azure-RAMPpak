variable "subscription_id" {
  type    = string
  default = "25e052ab-016a-4f1f-975c-527197874987" # TAA-TM-USFed-Z-Prod
}

variable "tenant_id" {
  type    = string
  default = "993dd03d-e5b4-436f-a31e-aa9c7d055dcb" # Wolters Kluwer US FedRAMP
}

variable "app_abbreviation" {
  description = "A abbreviation that should be attached to the names of resources"
  type        = string
  default     = "tm"
}

# don't think this is needed or a good idea. added spaces to the var name so it doesn't come up in search
# variable "default _azure _location" {
#   description = "The Azure location/region to create resources in"
#   type        = string
#   default     = "eastus2"
# }

//variable "partition" {
//  type        = string
//  default     = "azure-us-gov"
//  description = "For commercial cloud use azure or for gov cloud use aws-us-gov"
//}
//variable "is_gov" {
//type        = bool
//default     = true
//description = "Whether or not the environment is being deployed in GovCloud"
//}

variable "global_tags" {
  type = map(string)
  default = {
    managed_by = "Terraform"
  }
}
