@description('The name of the Managed Identity resource.')
param userAssignedIdentityName string

@description('location for the the resources to deploy.')
param location string

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentityName
  location: location
}
