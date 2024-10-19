locals {
  common_tags = {
    ManagedBy = "Terraform"
    GitRepo   = "https://github.com/nominalnz/demo-terraform-azure-snowflake"
  }

  common_tags_list = [for key, value in local.common_tags : "${key}=${value}"]
}
