data "azuread_client_config" "current" {}

data "azuread_application" "oauth_server" {
  display_name = "sp-id-snowflake-management-demo-oauth-server"
}

data "azuread_service_principal" "oauth_server" {
  display_name = "sp-id-snowflake-management-demo-oauth-server"
}

resource "azuread_application" "oauth_client" {
  display_name = "sp-id-snowflake-management-demo-oauth-client"
  owners       = [data.azuread_client_config.current.object_id]
  tags         = local.common_tags_list

  required_resource_access {
    resource_app_id = data.azuread_application.oauth_server.client_id

    resource_access {
      id   = data.azuread_service_principal.oauth_server.app_role_ids["session:role:SNOWSQL_RL"]
      type = "Role"
    }
  }
}

resource "azuread_application_password" "oauth_client" {
  application_id = azuread_application.oauth_client.id
  display_name   = "local"
}

resource "azuread_service_principal" "oauth_client" {
  client_id                    = azuread_application.oauth_client.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Grant Admin Consent in the Portal
# resource "azuread_app_role_assignment" "oauth_client" {
#   app_role_id         = data.azuread_service_principal.oauth_server.app_role_ids["session:role:SNOWSQL_RL"]
#   principal_object_id = azuread_application.oauth_client.object_id
#   resource_object_id  = data.azuread_service_principal.oauth_server.object_id
# }

resource "azuread_application_federated_identity_credential" "github" {
  application_id = azuread_application.oauth_client.id
  display_name   = "github"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:nominalnz/demo-terraform-azure-snowflake:environment:Production"
}

# TEMP: Add role assignment for testing GH workflow
# data "azurerm_subscription" "current" {}

# resource "azurerm_role_assignment" "oauth_client" {
#   scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
#   role_definition_name = "Reader"
#   principal_id         = azuread_service_principal.oauth_client.id
# }
