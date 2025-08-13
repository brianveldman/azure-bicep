metadata name = 'Microsoft Security Copilot'
metadata description = 'Deploys Microsoft Security Copilot'
metadata owner = 'Brian Veldman'
metadata version = '1.0.0'
targetScope = 'subscription'

@description('Defing our input parameters')
param __env__ string
param __location__ string
param __shortLocation__ string = substring(__location__, 0, 6)
param __scUnits__ int
param __scCrossGeoCompute__ string
param __scGeo__ string

@description('Defining our variables')
var _scResourceGroupName_ = 'rg-security-copilot-${__env__}-${__shortLocation__}-001'
var _scCapacityName_ = 'sc-${__env__}-${__shortLocation__}-001'

@description('Resource Group Deployment')
resource scResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: _scResourceGroupName_
  location: __location__
}

module security 'modules/security.bicep' = {
  name: 'securityCopilot'
  scope: scResourceGroup
  params: {
    __location__: __location__
    __scUnits__: __scUnits__
    __scCrossGeoCompute__: __scCrossGeoCompute__
    _scCapacityName_: _scCapacityName_
    __scGeo__: __scGeo__
  }
}
