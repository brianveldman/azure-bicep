  metadata name = 'Entra External ID Tenant Deployment'
  metadata description = 'Deploys Entra External ID Tenant (CIAM)'
  metadata owner = 'Brian Veldman'
  metadata version = '1.0.0'
  targetScope = 'subscription'

  @description('Defing our input parameters')
  param __env__ string
  param __alzName__ string 
  param __location__ string
  param __ciamLocation__ string
  param __ciamName__ string
  param __ciamSkuName__ string
  param __ciamSkuTier__ string
  param __ciamCountryCode__ string

  @description('Defining our variables')
  var _ciamResourceGroupName_ = 'rg-${__alzName__}-ciam-${__env__}-centus-001'

  @description('Resource Group Deployment')
  resource ciamResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
    name: _ciamResourceGroupName_
    location: __location__
  }

  @description('Module Deployment')
  module modCiam './modules/ciam.bicep' = {
    name: 'module-ciam-deployment'
    params: {
      __ciamLocation__: __ciamLocation__
      __ciamName__: __ciamName__
      __ciamSkuName__: __ciamSkuName__
      __ciamSkuTier__: __ciamSkuTier__
      __ciamCountryCode__: __ciamCountryCode__
    }
    scope: ciamResourceGroup
  }
