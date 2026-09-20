metadata name = 'Azure Container App Job as code'
metadata description = 'This Bicep code deploys Azure Container App Job as code, to handle actions in Microsoft Azure'
metadata owner = 'Brian Veldman'
targetScope = 'subscription'

@allowed([
  'prod'
  'dev'
  'test'
])
@description('Defining our parameters')
param parEnvironment string = 'prod'
param parNumber string = '001'
param parLandingZone string = 'mgmt'
param parLocation string = 'westeurope'

@description('Defining our variables')
var varShortLocationName = substring(parLocation, 0, 6)

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-management-aca-${parEnvironment}-${varShortLocationName}-${parNumber}'
  location: parLocation
}

@description('Deploying our module for Azure Container App Job as code')
module modAca './modules/aca.bicep' = {
  name: 'mod-aca-full-${deployment().name}'
  params: {
    parEnvironment: parEnvironment
    parNumber: parNumber
    parLandingZone: parLandingZone
    parLocation: parLocation
  }
  scope: resourceGroup
}

@description('Assigning Reader role to the principal of the Azure Container App Job')
module modRa 'br/public:avm/res/authorization/role-assignment/sub-scope:0.1.1' = {
  params: {
    principalId: modAca.outputs.caMiPrincipalId
    roleDefinitionIdOrName: 'Reader'
  }
  dependsOn: [
    modAca
  ]
}
