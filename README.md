# Terraform

[Style Guide](https://developer.hashicorp.com/terraform/language/style)

# Snowflake

[How to configure Azure to issue OAuth tokens on behalf of a client to access Snowflake](https://community.snowflake.com/s/article/Create-External-OAuth-Token-Using-Azure-AD-For-The-OAuth-Client-Itself)

# Policy

1. [Install the Microsoft Graph PowerShell SDK](https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0)

1. Authenticate as a Service Principal to use Microsoft Graph:

    ```powershell
    $clientId = "99999999-9999-9999-9999-999999999999"
    $clientSecret = "99999~999999999999_99~9999999_9999999_9"
    $tenantId = "99999999-9999-9999-9999-999999999999"

    $tokenBody = @{
        Grant_Type    = "client_credentials"
        Scope         = "https://graph.microsoft.com/.default"
        Client_Id     = $clientId
        Client_Secret = $clientSecret
    }

    $tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Method POST -Body $tokenBody
    $accessToken = $tokenResponse.access_token

    # Convert the access token to a SecureString
    $secureAccessToken = ConvertTo-SecureString $accessToken -AsPlainText -Force

    # Connect to Microsoft Graph using the SecureString access token
    Connect-MgGraph -AccessToken $secureAccessToken
    ``` 

1. [Configure token lifetime policies (preview)](https://learn.microsoft.com/en-us/entra/identity-platform/configure-token-lifetimes)