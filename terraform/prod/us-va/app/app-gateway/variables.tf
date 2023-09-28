variable "appgateway_tags" {
  type        = map(string)
  description = "Key/Value tags that should be added to the Application Gateway"
  default     = {}
}