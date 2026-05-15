targetScope = 'subscription'

@description('Defining our Parameters')
param parCustomerName string
param parEnvironmentName string 
param parLocation string
param parSolutionName string 
param parContainerEnvironmentName string
param parLogAnalyticsName string
param parContainerName string 

@description('Defining our Variables')
var varResourceGroupName = 'rg-${parCustomerName}-aca-${parEnvironmentName}-${parLocation}-001'

@description('Defining our Resource Groups')
resource acaResourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: varResourceGroupName
  location: parLocation
}

@description('Defining our Modules')
module aca './modules/ai.bicep' = {
  name: 'deepseekr1-aca-deployment' 
  params: {
    parEnvironmentName: parEnvironmentName
    parLocation: parLocation
    parSolutionName: parSolutionName
    parContainerEnvironmentName: parContainerEnvironmentName
    parLogAnalyticsName: parLogAnalyticsName
    parContainerName: parContainerName
  }
  scope: acaResourceGroup
}
