metadata name = 'Azure Storage as code - Entra Only authentication'
metadata description = 'This Bicep code deploys Azure Storage as code with Entra Only authentication.'
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
param parLandingZone string = 'kerb'
param parLocation string = 'westeurope'

@description('Defining our variables')
var varShortLocationName = substring(parLocation,0,6)

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-${parLandingZone}-st-${parEnvironment}-${varShortLocationName}-${parNumber}'
  location: parLocation
}

@description('Deploying our module for Azure Storage as code')
module modSa './modules/sa.bicep' = {
  name: 'mod-sa-full-${deployment().name}'
  params: {
    parLocation: parLocation
    parEnvironment: parEnvironment
    parLandingZone: parLandingZone
    parNumber: parNumber

  }
  scope: resourceGroup
}
