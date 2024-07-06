targetScope = 'subscription'

@description('Main Parameters')
param __location__ string = 'westeurope'
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

var _aiResourceGroupName_ = 'rg-ai-${__env__}'
var _aiComputeVisionName_ = 'cv-ai-${__env__}'
var _aiComputeVisionSku_ = 'F0'

resource aiResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: _aiResourceGroupName_
  location: __location__
  tags: _tags_
}

module aiModule './modules/ai-cv.bicep' = {
  name: 'deployment-ai-cv-module-${__env__}'
  scope: aiResourceGroup
  params: {
    __location__: __location__
    _tags_: _tags_
    _aiComputeVisionName_ : _aiComputeVisionName_
    _aiComputeVisionSku_: _aiComputeVisionSku_
  }
}
