metadata name = 'Azure Container App Job as code'
metadata description = 'This Bicep code deploys Azure Container App Job as code, to handle actions in Microsoft Graph'
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
var varShortLocationName = substring(parLocation,0,6)
var varStName = 'st${parEnvironment}${parLandingZone}${varShortLocationName}${parNumber}'
var varShareName = 'scripts'
var varLogName = 'log-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
var varAppiName = 'appi-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
var varCaeName = 'cae-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
var varCajName = 'caj-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${parLandingZone}-aca-${parEnvironment}-${varShortLocationName}-${parNumber}'
  location: parLocation
}

@description('Deploying our module for Azure Container App Job as code')
module modAca './modules/aca.bicep' = {
  name: 'mod-aca-full-${deployment().name}'
  params: {
    parLocation: parLocation
    varStName: varStName
    varShareName: varShareName
    varLogName: varLogName
    varAppiName: varAppiName
    varCaeName: varCaeName
    varCajName: varCajName
  }
  scope: resourceGroup
}
