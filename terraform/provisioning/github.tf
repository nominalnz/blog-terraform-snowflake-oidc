data "github_repository" "main" {
  full_name = "nominalnz/demo-terraform-azure-snowflake"
}

resource "github_repository_environment" "production" {
  environment = "Production"
  repository  = data.github_repository.main.name
}

resource "github_actions_environment_secret" "azure_tenant_id" {
  repository      = data.github_repository.main.name
  environment     = github_repository_environment.production.environment
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azuread_client_config.current.tenant_id
}

resource "github_actions_environment_secret" "azure_client_id" {
  repository      = data.github_repository.main.name
  environment     = github_repository_environment.production.environment
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azuread_application.oauth_client.client_id
}

resource "github_actions_environment_secret" "azure_principal_id" {
  repository      = data.github_repository.main.name
  environment     = github_repository_environment.production.environment
  secret_name     = "AZURE_PRINCIPAL_ID"
  plaintext_value = azuread_service_principal.oauth_client.object_id
}

resource "github_actions_environment_secret" "oauth_server_identifier_uri" {
  repository      = data.github_repository.main.name
  environment     = github_repository_environment.production.environment
  secret_name     = "OAUTH_SERVER_IDENTIFIER_URI"
  plaintext_value = data.azuread_application.oauth_server.identifier_uris[0]
}

resource "github_actions_environment_secret" "snowflake_account" {
  repository      = data.github_repository.main.name
  environment     = github_repository_environment.production.environment
  secret_name     = "SNOWFLAKE_ACCOUNT"
  plaintext_value = data.snowflake_current_account.this.id
}
