# Setting Up GitHub and Creating a Workflow
Now that we have everything configured in Snowflake and Azure, it's time to set up our GitHub repository and create a workflow that leverages our OAuth setup.

## Adding OAuth Client and Server Details to GitHub

First, let's add the necessary secrets to our GitHub repository using Terraform.

**Note**: We're storing these as secrets for enhanced security. In a private context, using variables instead of secrets could be acceptable, but secrets provide an extra layer of protection by masking the values.

## Creating a GitHub Actions Workflow

I've stored everything here as a secret because this is recommended for security reasons. But in a private context, using variables instead of secrets should be fine. It just means that the values will be masked from users, reducing any potential attack vector. 

With the Terraforming complete, we are finally ready to create and run our GitHub Actions workflow. It was a lot of work to get to this point, I'll admit. But the idea with Terraform is that we can scale this to hundreds of clients with minimal overhead. And by eliminating long-lived credentials from the process, we can be worry-free, with no need to worry about secret rotation or anything like that.

## Create and run a GitHub Actions workflow

Now, let's create a workflow to test our setup. 

Let's break down the key components of this workflow:

1. **Permissions**: We set `id-token: write` to allow GitHub's OIDC provider to create a JSON Web Token for every run.
1. **Environment Variables**: We set job-scoped environment variables with the Snowflake connection details. The `CONNECTIONS_DEFAULT` prefix is used by the Snowflake CLI to identify connection parameters.
1. **Azure CLI Login**: This step uses the federated credentials we set up earlier. We use `allow-no-subscriptions: true` since we don't need to access any Azure resources directly.
1. **Get Snowflake access token**: We use the Azure CLI to obtain an access token for Snowflake, similar to our earlier validation step.
1. **Create config.toml**: The Snowflake CLI action requires a config file. We create a minimal one here.
1. **Install Snowflake CLI**: We use the official Snowflake CLI action to install the CLI.
1. **Execute Snowflake CLI command**: Finally, we test our connection to Snowflake using the `snow connection test` command.

With this workflow in place, you should be able to trigger it manually and confirm that your connection to Snowflake works as expected.