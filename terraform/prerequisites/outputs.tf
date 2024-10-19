output "terraform_client_id" {
  value = azuread_application.terraform.client_id
}

output "terraform_client_secret" {
  value     = azuread_application_password.terraform.value
  sensitive = true
}
