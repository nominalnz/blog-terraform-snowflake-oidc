output "oauth_server_identifier_uri" {
  value = data.azuread_application.oauth_server.identifier_uris[0]
}

output "oauth_client_secret" {
  value     = azuread_application_password.oauth_client.value
  sensitive = true
}

output "oauth_client_client_id" {
  value = azuread_application.oauth_client.client_id
}

output "oauth_client_principal_id" {
  value = azuread_service_principal.oauth_client.object_id
}

output "azure_tenant_id" {
  value = data.azuread_client_config.current.tenant_id
}

output "snowflake_account" {
  value     = github_actions_secret.snowflake_account.plaintext_value
  sensitive = true
}
