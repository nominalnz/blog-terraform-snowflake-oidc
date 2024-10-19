terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.53.1"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.96.0"
    }
  }
}

provider "snowflake" {
  role = "ACCOUNTADMIN"
}
