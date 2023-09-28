locals {
  subscription_ids = merge({ mgmt = var.subscription_id }, var.app_subscription_ids)
}