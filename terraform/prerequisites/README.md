# Prerequisites: Setting Up Your Environment

Before we dive into the main implementation, let's set up our environment. We'll need to configure Azure, Snowflake, and GitHub to ensure smooth sailing through the rest of the process.

## Azure Terraform Prerequisites

To provision Azure resources, we need specific API permissions. Here's what you need to know:

**Service Principal**: Use a service principal with the `Application.ReadWrite.OwnedBy` permission.`

- Why a service principal? It's ideal for automated solutions like ours.
- Why `Application.ReadWrite.OwnedBy`? It's the least privileged option, allowing our service principal to manage only the applications and service principals it owns.

**Optional Permissions**: To avoid manual [admin consent](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/grant-admin-consent?pivots=portal) for each new OAuth client, consider adding `AppRoleAssignment.ReadWrite.All` and `Application.Read.All` permissions. However, keeping a human-in-the-loop for information security approvals is often preferred in enterprise environments.

**Note**: We're generating a secret for the service principal to run Terraform locally. This isn't ideal for production environments - we'll introduce you to the awesomeness of federated credentials later!

## Snowflake Terraform Prerequisites

For Snowflake, we'll set up two separate roles: one for integration (like OAuth) and another for provisioning users. This granular approach is preferable to using the ACCOUNTADMIN role for everything.

**Integration Admin Role**: This role needs the CREATE INTEGRATION privilege.

**User Provisioning Role**: This role needs CREATE USER and CREATE ROLE privileges.

## GitHub Prerequisites

For GitHub, all we need to do is create an empty repository. This will serve as the foundation for our GitHub Actions workflows later on.