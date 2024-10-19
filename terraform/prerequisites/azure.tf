# Get the current client config
data "azuread_client_config" "current" {}

# Microsoft Graph API permissions
data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
}

# Create the app registration
resource "azuread_application" "terraform" {
  display_name = "sp-id-terraform"
  owners       = [data.azuread_client_config.current.object_id]

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]

    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.OwnedBy"]
      type = "Role"
    }
  }
}

# Generate a password for the app
resource "azuread_application_password" "terraform" {
  application_id = azuread_application.terraform.id
  display_name   = "local"
}

# Create a linked service principal
resource "azuread_service_principal" "terraform" {
  client_id                    = azuread_application.terraform.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Grant Admin Consent
resource "azuread_app_role_assignment" "msgraph_application_readwrite_ownedby" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["Application.ReadWrite.OwnedBy"]
  principal_object_id = azuread_service_principal.terraform.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}
