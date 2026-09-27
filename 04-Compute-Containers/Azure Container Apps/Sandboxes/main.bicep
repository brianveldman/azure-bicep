metadata name = 'Sandbox Group Deployment'
metadata description = 'This Bicep template deploys a sandbox group resource in Azure'
metadata version = '1.0.0'

@allowed([
  'prod'
  'dev'
  'test'
])
@description('Defining our parameters')
param parEnvironment string = 'prod'
param parNumber string = '001'
param parLandingZone string = 'corp'
param parLocation string = 'westeurope'

@description('Defining our variables')
var shortLocationName = substring(parLocation, 0, 6)

@description('Name of the sandbox group resource')
var sandboxGroupName = 'cas-${parLandingZone}-${parEnvironment}-${shortLocationName}-${parNumber}'

@description('Role ID for the data owner role assignment')
var dataOwnerRoleId = 'c24cf47c-5077-412d-a19c-45202126392c'

@description('Sandbox group resource deployment')
#disable-next-line BCP081 //Due FP new feature
resource sandboxGroup 'Microsoft.App/sandboxGroups@2026-02-01-preview' = {
  name: sandboxGroupName
  location: parLocation
  properties: {
    defaultCpu: '1'
    defaultMemory: '1Gi'
    defaultDisk: '10Gi'
    maxSandboxCount: 10
    defaultTimeoutSeconds: 3600
  }
}

@description('Role assignment for the data owner')
resource dataOwner 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(sandboxGroup.id, deployer().objectId, dataOwnerRoleId)
  scope: sandboxGroup
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', dataOwnerRoleId)
    principalId: deployer().objectId
    principalType: 'User'
  }
}
