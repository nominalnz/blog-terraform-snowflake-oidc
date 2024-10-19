##################################################################################################
# Integration Admin
##################################################################################################

resource "snowflake_account_role" "integration_admin" {
  name = "INTEGRATION_ADMIN"
}

resource "snowflake_grant_privileges_to_account_role" "integration_admin" {
  privileges        = ["CREATE INTEGRATION"]
  account_role_name = snowflake_account_role.integration_admin.name
  on_account        = true
}

resource "snowflake_grant_account_role" "integration_admin" {
  role_name        = snowflake_account_role.integration_admin.name
  parent_role_name = "ACCOUNTADMIN"
}

##################################################################################################
# User Provisioning
##################################################################################################

resource "snowflake_account_role" "azp_provisioner" {
  name = "AZP_PROVISIONER"
}

resource "snowflake_grant_privileges_to_account_role" "azp_provisioner" {
  privileges        = ["CREATE USER", "CREATE ROLE"]
  account_role_name = snowflake_account_role.azp_provisioner.name
  on_account        = true
}

resource "snowflake_grant_account_role" "azp_provisioner" {
  role_name        = snowflake_account_role.azp_provisioner.name
  parent_role_name = "ACCOUNTADMIN"
}
