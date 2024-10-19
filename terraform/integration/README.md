# Deploying the OAuth Server

With our prerequisites in place, we're ready to deploy the OAuth Server. This process involves setting up resources in both Azure and Snowflake. Let's break it down step by step.

## Azure Resources

We'll start by deploying the Azure resources using the service principal we created in the Azure Terraform Prerequisites section.

**Important Note on Scopes**: When implementing this in a production environment, it's crucial to have a deep understanding of scopes. The scope we've used here (`session:role:SNOWSQL_RL`) is quite restrictive, allowing clients to use only the `SNOWSQL_RL` role. If you need clients to use different roles, you'll need to either:

1. Add additional app roles for each required role, or
1. Configure the integration to allow for more flexible role assignment.

For more detailed information on scopes, refer to the scopes section in the [external OAuth documentation](https://docs.snowflake.com/en/user-guide/oauth-ext-overview#scopes).

## Snowflake Resources

Now, let's set up the Snowflake resources. One of the major advantages of using Terraform is that we can programmatically reference details about the Azure resources we just defined. This makes the process much more straightforward and less error-prone.

We'll use the `INTEGRATION_ADMIN` role for this part.