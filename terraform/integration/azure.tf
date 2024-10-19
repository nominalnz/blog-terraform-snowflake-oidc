data "azuread_client_config" "current" {}

# Generate a UUID for the app role
resource "random_uuid" "oauth_server_snowsql_rl_role" {}

# Create the OAuth Server
resource "azuread_application" "oauth_server" {
  display_name = "sp-id-snowflake-oauth-server"
  owners       = [data.azuread_client_config.current.object_id]

  # Create an app role with a Snowflake scope
  app_role {
    allowed_member_types = [
      "Application"
    ]
    description  = "Scope for SNOWSQL_RL to be used in CC grant flow"
    display_name = "SNOWSQL_RL"
    id           = random_uuid.oauth_server_snowsql_rl_role.result
    value        = "session:role:SNOWSQL_RL"
  }

  lifecycle {
    ignore_changes = [
      identifier_uris,
    ]
  }
}

# Set an identifier for the application
resource "azuread_application_identifier_uri" "oauth_server" {
  application_id = azuread_application.oauth_server.id
  identifier_uri = "api://${azuread_application.oauth_server.client_id}"
}

# Create and associate a service principal with the OAuth Server application
resource "azuread_service_principal" "oauth_server" {
  client_id                    = azuread_application.oauth_server.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}
