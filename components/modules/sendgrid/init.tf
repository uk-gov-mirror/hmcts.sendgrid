terraform {
  required_version = ">= 1.2.2"
  required_providers {
    azurerm = "~> 4.0"
    sendgrid = {
      source  = "anna-money/sendgrid"
      version = "1.1.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "api_key_vault"

  features {}
  subscription_id = local.sendgrid_config[var.environment].key_vault_subscription
}

provider "sendgrid" {
  api_key = data.azurerm_key_vault_secret.api.value
}
provider "sendgrid" {
  alias   = "subuser"
  api_key = data.azurerm_key_vault_secret.api.value
  subuser = sendgrid_subuser.user.username
}