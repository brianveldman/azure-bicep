metadata name = 'Microsoft Foundry & Models'
metadata description = 'This is a Bicep template to deploys Microsoft Foundry, Including Foundry Project and two AI-models <3'
metadata owner = 'Brian Veldman'
metadata version = '1.0.0'

/* TARGET SCOPE */
targetScope = 'subscription'

@description('Defining our input parameters')
param parEnvironment string
@allowed([
  'swedencentral'
])

param parLocation string 
param parAlzName string
param parDeploymentNumber string

@description('Defining our variables')
var shortEnvironmentMapping = {
  swedencentral: 'sdc' 
}

var shortEnvironment = shortEnvironmentMapping[parLocation] ?? parLocation
var resourceGroupName = 'rg-${parAlzName}-${parEnvironment}-${shortEnvironment}-${parDeploymentNumber}'

@description('Deploying our resourcegroup')
resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: parLocation
}

@description('Deploying our AI module')
module ai 'modules/ai.bicep' = {
  params: {
    parAlzName: parAlzName
    parEnvironment: parEnvironment
    parLocation: parLocation
    parDeploymentNumber: parDeploymentNumber
    shortEnvironment: shortEnvironment
  }
  scope: rg
}
