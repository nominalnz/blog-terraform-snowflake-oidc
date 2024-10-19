terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.53.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.2.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.96.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "snowflake" {
  role = "ACCOUNTADMIN"
}
