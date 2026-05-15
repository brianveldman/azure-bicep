metadata name = 'Maester Automation as Code <3'
metadata description = 'Deploys Maester Automation Account with modules and runbook for automated reports on Mon, Wed, Fri via Azure Web App with Entra ID Auth'
metadata owner = 'Maester'
targetScope = 'subscription'

extension microsoftGraphV1

@description('Defing our input parameters')
param __env__ string
param __cust__ string
param __location__ string
param __defaultTenantName__ string
param __maesterAppRoles__ array
param __maesterAutomationAccountModules__ array

@description('Defining our variables')
var _maesterAutomationVariables_ = [
  {
    name: 'appName'
    value: format('"{0}"', _appServiceName_)
    isEncrypted: false
  }
  {
    name: 'resourceGroupName'
    value: format('"{0}"', _maesterResourceGroupName_)
    isEncrypted: false
  }
  {
    name: 'tenantId'
    value: format('"{0}"', tenant().tenantId)
    isEncrypted: false
  }
  {
    name: 'tenant'
    value: format('"{0}"', __defaultTenantName__)
    isEncrypted: false
  }
  {
    name: 'enableTeamsTests'
    value: 'false'
    isEncrypted: false
  }
  {
    name: 'enableExchangeTests'
    value: 'false'
    isEncrypted: false
  }
  {
    name: 'enableComplianceTests'
    value: 'false'
    isEncrypted: false
  }
]

var _shortLocation_ = substring(__location__, 0, 6)
var _maesterResourceGroupName_ = 'rg-maester-${__env__}-${_shortLocation_}-001'
var _maesterAutomationAccountName_ = 'aa-maester-${__env__}-${_shortLocation_}-001'
var _suffix_ = substring(uniqueString(subscription().id), 0, 2)
var _maesterStorageAccountName_ = 'sa${__cust__}${_suffix_}${__env__}001'
var _maesterStorageBlobName_ = 'maester'
var _maesterStorageBlobFileName_ = 'maester.ps1'
var _appServiceName_ = 'app-maester-${_suffix_}-${__env__}-${_shortLocation_}-001'
var _appServicePlanName_ = 'asp-maester-${__env__}-${_shortLocation_}-001'

@description('Resource Group Deployment')
resource maesterResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: _maesterResourceGroupName_
  location: __location__
}

@description('Module Deployment')
module modAutomationAccount './modules/aa.bicep' = {
  name: 'module-automation-account-deployment'
  params: {
    __location__: __location__
    _maesterAutomationVariables_: _maesterAutomationVariables_
    _appServiceName_: _appServiceName_
    _maesterResourceGroupName_: _maesterResourceGroupName_
    _maesterAutomationAccountName_: _maesterAutomationAccountName_
    __maesterAutomationAccountModules__: __maesterAutomationAccountModules__
    _maesterStorageAccountName_: _maesterStorageAccountName_
    _maesterStorageBlobName_: _maesterStorageBlobName_
    _maesterStorageBlobFileName_: _maesterStorageBlobFileName_
  }
  scope: maesterResourceGroup
}

module modAutomationAccountAdvanced './modules/aa-advanced.bicep' = {
  name: 'module-automation-account-advanced-deployment'
  params: {
    __location__: __location__
    __ouMaesterAutomationMiId__: modAutomationAccount.outputs.__ouMaesterAutomationMiId__
    __ouMaesterScriptBlobUri__: modAutomationAccount.outputs.__ouMaesterScriptBlobUri__
    _maesterAutomationAccountName_: _maesterAutomationAccountName_
    __maesterAppRoles__:  __maesterAppRoles__

  }
  scope: maesterResourceGroup
}

module modAppService './modules/app-service.bicep' = {
  name: 'module-app-service-deployment'
  params: {
    __location__: __location__
    __ouMaesterAutomationMiId__: modAutomationAccount.outputs.__ouMaesterAutomationMiId__
    _appServiceName_: _appServiceName_
    _appServicePlanName_: _appServicePlanName_
  }
  scope: maesterResourceGroup
}
