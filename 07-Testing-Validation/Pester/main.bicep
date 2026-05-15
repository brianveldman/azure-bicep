targetScope = 'subscription'

@description('Defining our params')
param __env__ string = 'prod'
param __location__ string = 'westeurope'

@description('Defining our vars')
var _saResourceGroupName_ = 'rg-storage-${__env__}'
var _appResourceGroupName_ = 'app-storage-${__env__}'

var _azTags_ = {
  environment: __env__
  owner: 'Brian Veldman'
}

resource saResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: _saResourceGroupName_
  location: __location__
  tags: _azTags_
}

resource appResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: _appResourceGroupName_
  location: __location__
  tags: _azTags_
}

module sa './modules/storage-account.bicep' = {
  name: 'module-deployment-storage'
  params: {
    __location__: __location__
    _azTags_: _azTags_
  }
  scope: saResourceGroup
}

module app './modules/web-app.bicep' = {
  name: 'module-deployment-app'
  params: {
    __location__: __location__
    _azTags_: _azTags_
  }
  scope: appResourceGroup
}
