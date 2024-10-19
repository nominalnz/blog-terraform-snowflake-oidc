terraform {
  backend "azurerm" {
    resource_group_name  = "rg-management"
    storage_account_name = "stnmnllztfstate"
    container_name       = "snowflake-management-demo"
    key                  = "prerequisites.tfstate"
  }
}
