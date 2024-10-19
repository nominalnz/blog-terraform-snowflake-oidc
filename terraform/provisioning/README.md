# Provisioning an OAuth Client

With our OAuth Server in place, let's move on to provisioning a user. Remember, you can use one OAuth Server for multiple clients, so there's no need to create a new server for each client unless you have a specific reason to do so.

## Azure Resources

We'll start by setting up the Azure resources using the same service principal as before. 

**Important Note on Admin Consent**: As mentioned in the overview, we're keeping a human-in-the-loop for admin consent. This means you'll need to manually grant admin consent in the Azure Portal after running this Terraform code. In a future article, we'll explore how to automate this process with low privileges, allowing our service principal to manage only the app roles relevant to our OAuth Server.

## Snowflake Resources

Now, let's set up the corresponding Snowflake resources. We'll use the `AZP_PROVISIONER` role for this part. 

With these Terraform configurations, we've successfully:

1. Created an OAuth Client in Azure
1. Set up the necessary permissions for the client to access our OAuth Server
1. Created a corresponding Snowflake user and role
1. Linked the Azure service principal to the Snowflake user

The Azure service principal and Snowflake user are now set up with matching permissions, aligning with the API permissions we configured earlier.

Now that we have everything set up, the next step is to validate our configuration. In the next section, we'll walk through the process of testing our OAuth setup to ensure everything is working as expected.

# Validate the OAuth configuration

Now that we've set up our OAuth Server and Client, it's crucial to validate that everything is working correctly. We'll do this in two steps: first, we'll generate an access token, and then we'll verify it in Snowflake.

## Step 1: Generating an Access Token

We can use a simple bash script with `curl` to generate an access token.

```bash
./get-access-token
```

This script does the following:

1. Makes a POST request to the Azure Entra ID token endpoint
1. Uses Terraform output commands to dynamically retrieve the necessary credentials and identifiers
1. Extracts the access token from the JSON response using jq
1. Prints the access token

Run this script and copy the output (the access token) for the next step.

## Step 2: Validating the Token in Snowflake

Now that we have our access token, we can validate it in Snowflake. Run the following SQL command in your Snowflake workspace:

```sql
SELECT SYSTEM$VERIFY_EXTERNAL_OAUTH_TOKEN('your_access_token_here');
```

Replace `'your_access_token_here'` with the token you generated in Step 1.

A successful validation will return a result similar to this:

```
Token Validation finished.
{
    "Validation Result":"Passed",
    "Issuer":"https://sts.windows.net/00000000-0000-0000-0000-000000000000/",
    "Extracted User claim(s) from token":"d36d0d87-888b-4aed-ba97-7e62e17a30c0"}
```

If you see a result like the one above, congratulations! Your OAuth configuration is working correctly. This validation confirms that:

1. Your Azure AD OAuth Server is correctly issuing tokens
1. Your Snowflake External OAuth Integration is properly configured to recognise and validate these tokens
1. The user claims in the token match the expected format for Snowflake

*The ID in the "Extracted User claim(s) from token" (in this example, "4c99a1d6–50ce-4e7d-9cc2–429c26d613df") is the object ID of the service principal for the OAuth client. This ID corresponds to the `login_name` we set for the Snowflake user in our earlier Terraform configuration.*

While we could use this token to connect to Snowflake directly, that's not our end goal. 

We've successfully validated that our OAuth setup is working correctly, which is a crucial step.

Our ultimate aim is to use federated credentials to connect to Snowflake from a GitHub Actions workflow without any passwords or long-lived secrets. In the next section, we'll explore how to set this up, leveraging the OAuth configuration we've just validated.

# Adding Federated Credentials to the OAuth Client

Now that we have our OAuth client set up and validated, let's configure it for federated credentials. This step is crucial for enabling passwordless authentication from GitHub Actions to our Azure resources and, by extension, to Snowflake.

## Configuring Federated Credentials with Terraform

One of the great advantages of using Terraform is that we can manage this entire process end-to-end. We just need to add a new resource to our existing Terraform configuration. Here's an example:

```hcl
resource "azuread_application_federated_identity_credential" "example" {
  application_id = azuread_application_registration.oauth_client.id
  display_name = "my-snowflake-repo"
  description = "Deployments for my-snowflake-repo"
  audiences = ["api://AzureADTokenExchange"]
  issuer = "https://token.actions.githubusercontent.com"
  subject = "repo:my-organization/my-snowflake-repo:ref:refs/heads/main"
}
```

Let's break down the key components of this resource:

- `application_id`: This should match the ID of your OAuth client application.
- `display_name` and `description`: These are for your reference and can be customised as needed.
- `audiences`: This is a fixed value for GitHub Actions.
- `issuer`: This is the token issuer for GitHub Actions.
- `subject`: This is where you specify which GitHub workflows can use this OAuth client.

## Customising the Subject Claim

The `subject` field is particularly important as it determines the scope of access. In the example above, we've limited usage to main branch of the `my-snowflake-repo` in the `my-organisation` organisation. You should adjust this to match your specific repository details.

You can further restrict access by specifying branches, environments, or other GitHub Actions contexts. For example:

- To limit to a specific branch: `repo:my-organisation/my-snowflake-repo:ref:refs/heads/main`
- To limit to a specific environment: `repo:my-organisation/my-snowflake-repo:environment:dev`

## Best Practices

1. Use Environments: While not implemented in this example, it's highly recommended to use GitHub Environments for your Terraform deployments. Environments allow you to implement additional controls, such as requiring approvals before deployment.
2. Least Privilege: Always follow the principle of least privilege. Only grant access to the specific repositories, branches, or environments that need it.
3. Regular Audits: Regularly review and audit your federated credentials to ensure they reflect your current security needs.

For a comprehensive list of subject claim options and examples of how to use them, refer to the [GitHub documentation on OpenID Connect](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect).