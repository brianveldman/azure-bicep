metadata name = 'Microsoft Graph Permissions Assignment'
metadata description = 'This Bicep code assigns Microsoft Graph API permissions to a managed identity.'
metadata owner = 'Brian Veldman'

targetScope = 'subscription'

//Loading Micrsosoft Graph extension
extension microsoftGraphV1

@description('Defing our input parameters')
param __appRolesToAssign__ array
param __resourceGroupName__ string 
param __managedIdentityName__ string

@description('Retrieving the existing resource group and managed identity')
resource existingResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: __resourceGroupName__
}
resource userManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = {
  name: __managedIdentityName__
  scope: resourceGroup(existingResourceGroup.name)
}

resource managedIdentityServicePrincipal 'Microsoft.Graph/servicePrincipals@v1.0' existing = {
  appId: userManagedIdentity.properties.clientId
}

resource graphServicePrincipal 'Microsoft.Graph/servicePrincipals@v1.0' existing = {
  appId: '00000003-0000-0000-c000-000000000000'
}

  // You can also do this for System Assigned Managed Identities, for example: automationAccount.identity.principalIdresource 
  assignAppRole 'Microsoft.Graph/appRoleAssignedTo@v1.0' = [for appRole in __appRolesToAssign__: {
  appRoleId: (filter(graphServicePrincipal.appRoles, role => role.value == appRole)[0]).id
  principalId: managedIdentityServicePrincipal.id
  resourceId: graphServicePrincipal.id
}]
