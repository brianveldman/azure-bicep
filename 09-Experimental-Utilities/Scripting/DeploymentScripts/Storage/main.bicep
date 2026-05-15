metadata name = 'Azure Bicep & Azure Deployment Script'
metadata description = 'Using this Bicep file we deploy some basic Azure services and use Azure Deployment script for dataplane actions <3'
metadata owner = 'Brian Veldman'
targetScope = 'subscription'

@description('Main Parameters')
param __location__ string = 'westeurope'
param __env__ string = 'prod'
param __cust__ string = 'ct'
param __startDate__ string = utcNow('d-M-yyyy')
param __author__ string = 'Brian Veldman'
param __website__ string = 'CloudTips.nl'

@description('Tagging Variables')
var _tags_ = {
  createdBy: __author__
  website: __website__
  environment: __env__
  startDate: __startDate__
}

@description('Resource Groups')
var _saRgName_ = 'rg-storage-${__env__}'

@description('Storage Variables')
var _saName_ = 'sactbvtestingdeploy'
var _saContainerName_ = 'sa${__cust__}container'

@description('MI Variables')
var _miName_ = 'id-${__cust__}-deployment-${__env__}'

@description('MI Variables')
var _deploymentScriptName_ = 'deploymentScript-${__cust__}-${__env__}'

resource saRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: _saRgName_
  location: __location__
  tags: _tags_
}

module sa './modules/sa.bicep' = {
  name: 'module-sa-deployment'
  params: {
    __location__: __location__
    __cust__: __cust__
    _tags_: _tags_
    _saName_: _saName_
    _saContainerName_: _saContainerName_
    _miName_: _miName_
    _deploymentScriptName_: _deploymentScriptName_
  }
  scope: saRg
}
