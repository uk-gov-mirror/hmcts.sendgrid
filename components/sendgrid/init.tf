terraform {
  required_version = ">= 1.2.2"
  backend "azurerm" {}
  required_providers {
    azurerm = "~> 4.0"
    sendgrid = {
      source  = "anna-money/sendgrid"
      version = "1.1.2"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "api_key_vault"
  features {}
  subscription_id = local.sendgrid_config[var.env].key_vault_subscription
}

data "azurerm_key_vault" "kv" {
  provider = azurerm.api_key_vault

  name                = "sendgrid${var.env}"
  resource_group_name = "SendGrid-${var.env}"
}

data "azurerm_key_vault_secret" "api" {
  provider = azurerm.api_key_vault

  name         = "platform-operations-api-key"
  key_vault_id = data.azurerm_key_vault.kv.id
}

provider "sendgrid" {
  api_key = data.azurerm_key_vault_secret.api.value
}