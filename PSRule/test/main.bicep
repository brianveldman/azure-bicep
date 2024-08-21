targetScope = 'subscription'


@description('Main Parameters')
param __location__ string = 'eastus'
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
var _saResourceGroupName_ = 'rg-test-sact'
var _storageAccountName_ = 'sacttest01'

@description('Deploying Resource Group')
resource saResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: _saResourceGroupName_ 
  location: __location__
  tags: _tags_
}

module storageAccount './modules/storageAccount.bicep' = {
  name: 'storageAccount'
  params: {
    __location__: __location__
    _storageAccountName_: _storageAccountName_
  }
  scope: saResourceGroup
}
