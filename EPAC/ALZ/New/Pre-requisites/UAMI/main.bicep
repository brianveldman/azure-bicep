@description('location for the the resources to deploy.')
param location string = resourceGroup().location

@description('The name of the Managed Identity resource.')
param userAssignedIdentityName string = 'id-ama-prod'

@description('The name of the resource group where the Managed Identity resource will be created.')
param userAssignedIdentityResourceGroup string

module userAssignedIdentity './uami.bicep' = {
  name: userAssignedIdentityName
  scope: resourceGroup(userAssignedIdentityResourceGroup)
  params: {
    userAssignedIdentityName: userAssignedIdentityName
    location: location
  }
}
