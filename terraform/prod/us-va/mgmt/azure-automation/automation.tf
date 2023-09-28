resource "azurerm_automation_account" "va-aa" {
  name                = "${local.resource_prefix}-aa"
  location            = var.location
  resource_group_name = data.terraform_remote_state.setup.outputs.management_rg_name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = merge({
    Function    = "Automation"
    Plane       = "Management"
    Environment = "Production"
  }, var.global_tags, var.regional_tags, local.global_local_tags)
}

data "local_file" "runningscript" {
  filename = "../../../../../shellscripts/windows/Set-VMRunningState.ps1"
}

resource "azurerm_automation_runbook" "stopinator" {
  name                    = "Set-VMRunningState"
  location                = var.location
  resource_group_name     = data.terraform_remote_state.setup.outputs.management_rg_name
  automation_account_name = azurerm_automation_account.va-aa.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Starts/Stops VM's based on tag values"
  runbook_type            = "PowerShell"
  content                 = data.local_file.runningscript.content
}

resource "azurerm_automation_schedule" "hour" {
  name                    = "tm-hour-schedule"
  resource_group_name     = data.terraform_remote_state.setup.outputs.management_rg_name
  automation_account_name = azurerm_automation_account.va-aa.name
  frequency               = "Hour"
  interval                = 1
  timezone                = "America/New_York"
  description             = "Hourly Run Schedule"
}

resource "azurerm_automation_job_schedule" "stopinator" {
  resource_group_name     = data.terraform_remote_state.setup.outputs.management_rg_name
  automation_account_name = azurerm_automation_account.va-aa.name
  schedule_name           = azurerm_automation_schedule.hour.name
  runbook_name            = azurerm_automation_runbook.stopinator.name
}

resource "azurerm_log_analytics_linked_service" "aa_la_link" {
  resource_group_name = data.terraform_remote_state.core.outputs.core_rg_name
  workspace_id        = data.terraform_remote_state.core.outputs.core_la_id
  read_access_id      = azurerm_automation_account.va-aa.id
}