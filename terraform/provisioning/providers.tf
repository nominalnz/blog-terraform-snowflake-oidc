terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.96.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.53.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    github = {
      source  = "integrations/github"
      version = "6.3.0"
    }
  }
}

provider "snowflake" {
  role = "AZP_PROVISIONER"
}

provider "azurerm" {
  features {}
}
