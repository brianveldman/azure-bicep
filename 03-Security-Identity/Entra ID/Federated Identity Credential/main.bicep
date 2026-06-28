metadata name = 'Graph API Application with Federated Identity Credential'
metadata description = 'Deploys a Graph API Application with a Federated Identity Credential that trusts a User Assigned Managed Identity to impersonate the application.'
metadata owner = 'Brian Veldman'
metadata version = '1.0.0'

/* TARGET SCOPE */
targetScope = 'subscription'
/* EXTENSIONS */
extension 'br:mcr.microsoft.com/bicep/extensions/microsoftgraph/v1.0:0.1.8-preview'

@description('Defining our input parameters')
param parLocation string = 'westeurope'

@description('Defining our variables')
var resourceGroupName = 'rg-fic-demo'
var managedIdentityName = 'mi-fic-demo'
var applicationDisplayName = 'fic-demo-app'
var applicationName = 'fic-demo-app'

module rg 'br/public:avm/res/resources/resource-group:0.4.3' = {
  params: {
    name: resourceGroupName
    location: parLocation
  }
}

module uami 'br/public:avm/res/managed-identity/user-assigned-identity:0.5.1' = {
  scope: resourceGroup(resourceGroupName)
  params: {
    name: managedIdentityName
  }
}

resource app 'Microsoft.Graph/applications@v1.0' = {
  displayName: applicationDisplayName
  uniqueName: applicationName
   signInAudience: 'AzureADMultipleOrgs'
   defaultRedirectUri: 'https://admin.microsoft.com'

  resource msiFic 'federatedIdentityCredentials@v1.0' = {
    name: '${app.uniqueName}/msiAsFic'
    description: 'Trust the workloads UAMI to impersonate the App'
    audiences: [
       'api://AzureADTokenExchange'
    ]
    issuer: '${environment().authentication.loginEndpoint}${tenant().tenantId}/v2.0'
    subject: uami.outputs.principalId
  }
  dependsOn: [
    uami
  ]
}
