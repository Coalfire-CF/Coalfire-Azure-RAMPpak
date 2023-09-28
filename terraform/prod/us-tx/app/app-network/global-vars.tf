variable "subscription_id" {
  type    = string
  default = "" # 
}

variable "tenant_id" {
  type    = string
  default = "" # 
}

variable "app_abbreviation" {
  description = "A abbreviation that should be attached to the names of resources"
  type        = string
  default     = "lp"
}

variable "global_tags" {
  type = map(string)
  default = {
    managed_by = "Terraform"
  }
}
