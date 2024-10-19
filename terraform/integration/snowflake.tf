# resource "random_password" "azp_provisioner" {
#   length  = 16
#   special = false
# }

# resource "snowflake_user" "azp_provisioner" {
#   name         = "AZP_PROVISIONER_USER"
#   login_name   = "AZP_PROVISIONER_USER"
#   display_name = "AZP_PROVISIONER_USER"
#   password     = random_password.azp_provisioner.result
# }

# resource "snowflake_account_role" "azp_provisioner" {
#   name = "AZP_PROVISIONER"
# }

# resource "snowflake_grant_privileges_to_account_role" "azp_provisioner" {
#   privileges        = ["CREATE USER", "CREATE ROLE"]
#   account_role_name = snowflake_account_role.azp_provisioner.name
#   on_account        = true
# }

# resource "snowflake_grant_account_role" "azp_provisioner" {
#   role_name = snowflake_account_role.azp_provisioner.name
#   user_name = snowflake_user.azp_provisioner.name
# }

# resource "snowflake_grant_account_role" "_azp_provisioner" {
#   role_name        = snowflake_account_role.azp_provisioner.name
#   parent_role_name = "ACCOUNTADMIN"
# }

resource "snowflake_external_oauth_integration" "azure" {
  external_oauth_issuer                           = "https://sts.windows.net/${data.azuread_client_config.current.tenant_id}/"
  external_oauth_snowflake_user_mapping_attribute = "login_name"
  external_oauth_token_user_mapping_claim         = ["sub"]
  external_oauth_type                             = "azure"
  name                                            = "EXTERNAL_OAUTH_AZURE"
  external_oauth_audience_list                    = [azuread_application_identifier_uri.oauth_server.identifier_uri]
  external_oauth_jws_keys_url                     = ["https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/discovery/v2.0/keys"]
  enabled                                         = true
}
