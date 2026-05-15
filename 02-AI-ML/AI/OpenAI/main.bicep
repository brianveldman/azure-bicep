targetScope = 'subscription'

@description('Main Parameters')
param __location__ string = 'eastus'
param __cust__ string = 'ct'
param __env__ string = 'prod'
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

@description('Defining our vars')
var _oaiResourceGroupName_ = 'rg-oai-${__env__}'
var _oaiResourceName_ = 'oai-${__cust__}-${__env__}'
var _oaiKind_ = 'OpenAI'
var _oaiSku_ = 'S0'
var _oaiModelName_ = 'gpt-4o'
var _oaiApiVersion_ = '2024-05-13'
var _oaiDeploymentModelName_ = 'oai-gpt4-model-${__env__}'

@description('Defining our resoure groups')
resource oaiResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: _oaiResourceGroupName_
  location: __location__
  tags: _tags_
}

@description('Defining our module deployments')
module oaiModule './modules/oai.bicep' = {
  name: 'oai-module-deployment'
  params: {
    __location__: __location__
    _tags_: _tags_
    _oaiResourceName_: _oaiResourceName_
    _oaiKind_: _oaiKind_
    _oaiApiVersion_: _oaiApiVersion_
    _oaiSku_: _oaiSku_
    _oaiModelName_: _oaiModelName_
    _oaiDeploymentModelName_: _oaiDeploymentModelName_
  }
  scope: oaiResourceGroup
}
