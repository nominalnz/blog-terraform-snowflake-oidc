data "github_repository" "main" {
  full_name = "nominalnz/blog-terraform-snowflake-oidc"
}

data "snowflake_current_account" "this" {}

resource "github_actions_secret" "azure_tenant_id" {
  repository      = data.github_repository.main.name
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azuread_client_config.current.tenant_id
}

resource "github_actions_secret" "azure_client_id" {
  repository      = data.github_repository.main.name
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azuread_application.oauth_client.client_id
}

resource "github_actions_secret" "azure_principal_id" {
  repository      = data.github_repository.main.name
  secret_name     = "AZURE_PRINCIPAL_ID"
  plaintext_value = azuread_service_principal.oauth_client.object_id
}

resource "github_actions_secret" "oauth_server_identifier_uri" {
  repository      = data.github_repository.main.name
  secret_name     = "OAUTH_SERVER_IDENTIFIER_URI"
  plaintext_value = data.azuread_application.oauth_server.identifier_uris[0]
}

resource "github_actions_secret" "snowflake_account" {
  repository  = data.github_repository.main.name
  secret_name = "SNOWFLAKE_ACCOUNT"
  plaintext_value = element(
    regex("^https://(.+)\\.snowflakecomputing\\.com$", data.snowflake_current_account.this.url),
    0
  )
}
