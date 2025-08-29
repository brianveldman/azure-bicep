
metadata name = 'Storage Account Deployment'
metadata description = 'Deploys a Storage Account using Azure Verified Modules (AVM)'
metadata owner = 'Brian Veldman'
metadata version = '1.0.0'
targetScope = 'subscription'

@description('Defining our parameters')
param parEnvironment string = 'dev'
param parLocation string = 'westeurope'

@description('Defining our variables')
var varShortLocation = substring(parLocation, 0, 6)
var varStorageResourceGroupName = 'rg-storage-${parEnvironment}-${varShortLocation}-001'
var varStorageAccountName = toLower('st${parEnvironment}${varShortLocation}001')

@description('Create a Resource Group for Storage Account')
resource storageResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: varStorageResourceGroupName
  location: parLocation
}

@description('Deploy a Storage Account using AVM module')
module storageAccount 'br/public:avm/res/storage/storage-account:0.26.2' = {
  name: 'avm-storage-deployment-${parEnvironment}-${varShortLocation}-001'
  params: {
    name: varStorageAccountName
    location: parLocation
  }
  scope: storageResourceGroup
}
