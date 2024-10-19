output "terraform_client_id" {
  value = azuread_application.terraform.client_id
}

output "terraform_secret" {
  value     = azuread_application_password.terraform.value
  sensitive = true
}

output "azp_provisioner_user" {
  value = snowflake_user.azp_provisioner.name
}

output "azp_provisioner_password" {
  value     = snowflake_user.azp_provisioner.password
  sensitive = true
}

output "azp_provisioner_role" {
  value = snowflake_account_role.azp_provisioner.name
}

output "integration_admin_user" {
  value = snowflake_user.integration_admin.name
}

output "integration_admin_password" {
  value     = snowflake_user.integration_admin.password
  sensitive = true
}

output "integration_admin_role" {
  value = snowflake_account_role.integration_admin.name
}

output "policy_client_id" {
  value = azuread_application.policy.client_id
}

output "policy_secret" {
  value     = azuread_application_password.policy.value
  sensitive = true
}
