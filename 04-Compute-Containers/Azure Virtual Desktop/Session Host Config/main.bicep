metadata name = 'Azure Virtual Desktop Session Host Config (SHC) Deployment'
metadata description = 'Deploys Azure Virtual Desktop Session Host Config (SHC) resources for lab'
metadata owner = 'Brian Veldman'
metadata version = '1.0.0'

targetScope = 'subscription'

@description('Defining our input parameters')
@allowed([
  'westeurope'
  'northeurope'
  'germanywestcentral'
  'canadacentral'
  'australiaeast'
])
param parLocation string = 'westeurope'
param parEnvironment string = 'prod'
param parLandingZone string = 'corp'
param parNumber string = '001'

@secure()
@description('Will be filled out by the user in the deployment process')
param parLocalAdminPasswordSecretName string 
param parLocalAdminUsernameSecretName string = 'vdadmin'
param parStartDate string = utcNow('yyyy-MM-dd')
param parTags object = {
  environment: parEnvironment
  location: parLocation
  deploymentNumber: parNumber
  startDate: parStartDate
  landingZone: parLandingZone
}

@description('Defining our Variables')
var varShortEnvironmentMapping = {
  westeurope: 'weu'
  northeurope: 'neu'
  germanywestcentral: 'dewc'
  canadacentral: 'cac'
  australiaeast: 'eau'
}
var varShortEnvironment = varShortEnvironmentMapping[parLocation] ?? parLocation

@description('Creating Resource Group for AVD Deployment')
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-avd-${parLandingZone}-${parEnvironment}-${varShortEnvironment}-${parNumber}'
  location: parLocation
  tags: parTags
}

@description('Deploying AVD Module')
module avd './modules/avd.bicep' = {
  params: {
    parLocation: parLocation
    parEnvironment: parEnvironment
    parLandingZone: parLandingZone
    parNumber: parNumber
    parTags: parTags
    varShortEnvironment: varShortEnvironment
    parLocalAdminPasswordSecretName: parLocalAdminPasswordSecretName
    parLocalAdminUsernameSecretName: parLocalAdminUsernameSecretName
  }
  scope: rg
}
