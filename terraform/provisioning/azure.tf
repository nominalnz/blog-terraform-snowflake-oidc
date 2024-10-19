data "azuread_client_config" "current" {}

# Reference the OAuth Server application
data "azuread_application" "oauth_server" {
  display_name = "sp-id-snowflake-oauth-server"
}

# Reference the OAuth Server service principal
data "azuread_service_principal" "oauth_server" {
  display_name = "sp-id-snowflake-oauth-server"
}

# Create an OAuth Client
resource "azuread_application" "oauth_client" {
  display_name = "sp-id-snowflake-oauth-client"
  owners       = [data.azuread_client_config.current.object_id]
  tags         = local.common_tags_list

  # Add the Snowflake scope API permission
  required_resource_access {
    resource_app_id = data.azuread_application.oauth_server.client_id

    resource_access {
      id   = data.azuread_service_principal.oauth_server.app_role_ids["session:role:SNOWSQL_RL"]
      type = "Role"
    }
  }
}

# Create a password for local testing purposes
resource "azuread_application_password" "oauth_client" {
  application_id = azuread_application.oauth_client.id
  display_name   = "local"
}

# Create and associate a service principal with the OAuth Client application
resource "azuread_service_principal" "oauth_client" {
  client_id                    = azuread_application.oauth_client.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Configure federated credentials for GitHub Actions
resource "azuread_application_federated_identity_credential" "example" {
  application_id = azuread_application.oauth_client.id
  display_name   = "blog-terraform-snowflake-oidc"
  description    = "Deployments for blog-terraform-snowflake-oidc"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:nominalnz/blog-terraform-snowflake-oidc:ref:refs/heads/main"
}
