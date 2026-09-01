metadata name = 'Cognitive Services Account with Model Router'
metadata description = 'This is a Bicep template to deploy a Cognitive Services Account with the Model Router deployment.'
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

@description('Defining our variables')
var shortEnvironmentMapping = {
  swedencentral: 'sdc' // Supported for Model Router in Foundry
}

var shortEnvironment = shortEnvironmentMapping[parLocation] ?? parLocation
var resourceGroupName = 'rg-${parAlzName}-${parEnvironment}-${shortEnvironment}-001'

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
    shortEnvironment: shortEnvironment
  }
  scope: rg
}
