##################################################################################################
# Azure Service Principal Provisioner
##################################################################################################

resource "random_password" "azp_provisioner" {
  length  = 16
  special = false
}

resource "snowflake_user" "azp_provisioner" {
  name         = "AZP_PROVISIONER_USER"
  login_name   = "AZP_PROVISIONER_USER"
  display_name = "AZP_PROVISIONER_USER"
  password     = random_password.azp_provisioner.result
}

resource "snowflake_account_role" "azp_provisioner" {
  name = "AZP_PROVISIONER"
}

resource "snowflake_grant_privileges_to_account_role" "azp_provisioner" {
  privileges        = ["CREATE USER", "CREATE ROLE"]
  account_role_name = snowflake_account_role.azp_provisioner.name
  on_account        = true
}

resource "snowflake_grant_account_role" "azp_provisioner" {
  role_name = snowflake_account_role.azp_provisioner.name
  user_name = snowflake_user.azp_provisioner.name
}

resource "snowflake_grant_account_role" "_azp_provisioner" {
  role_name        = snowflake_account_role.azp_provisioner.name
  parent_role_name = "ACCOUNTADMIN"
}

##################################################################################################
# Integration
##################################################################################################

resource "random_password" "integration_admin" {
  length  = 16
  special = false
}

resource "snowflake_user" "integration_admin" {
  name         = "INTEGRATION_ADMIN_USER"
  login_name   = "INTEGRATION_ADMIN_USER"
  display_name = "INTEGRATION_ADMIN_USER"
  password     = random_password.integration_admin.result
}

resource "snowflake_account_role" "integration_admin" {
  name = "INTEGRATION_ADMIN"
}

resource "snowflake_grant_privileges_to_account_role" "integration_admin" {
  privileges        = ["CREATE INTEGRATION"]
  account_role_name = snowflake_account_role.integration_admin.name
  on_account        = true
}

resource "snowflake_grant_account_role" "integration_admin" {
  role_name = snowflake_account_role.integration_admin.name
  user_name = snowflake_user.integration_admin.name
}

resource "snowflake_grant_account_role" "_integration_admin" {
  role_name        = snowflake_account_role.integration_admin.name
  parent_role_name = "ACCOUNTADMIN"
}

##################################################################################################
# Snowpark Container Services Admin
##################################################################################################

# resource "random_password" "spcs_admin" {
#   length  = 16
#   special = false
# }

# resource "snowflake_user" "spcs_admin" {
#   name         = "SPCS_ADMIN_USER"
#   login_name   = "SPCS_ADMIN_USER"
#   display_name = "SPCS_ADMIN_USER"
#   password     = random_password.spcs_admin.result
# }

# resource "snowflake_account_role" "spcs_admin" {
#   name = "SPCS_ADMIN"
# }

# resource "snowflake_grant_privileges_to_account_role" "spcs_admin" {
#   privileges = [
#     "CREATE DATABASE",
#     "BIND SERVICE ENDPOINT",
#     "CREATE COMPUTE POOL",
#     "CREATE WAREHOUSE"
#   ]
#   account_role_name = snowflake_account_role.spcs_admin.name
#   on_account        = true
# }

# resource "snowflake_grant_account_role" "spcs_admin" {
#   role_name = snowflake_account_role.spcs_admin.name
#   user_name = snowflake_user.spcs_admin.name
# }

# resource "snowflake_grant_account_role" "_spcs_admin" {
#   role_name        = snowflake_account_role.spcs_admin.name
#   parent_role_name = "ACCOUNTADMIN"
# }
