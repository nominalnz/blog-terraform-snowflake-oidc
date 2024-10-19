# Create the External OAuth Integration
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
