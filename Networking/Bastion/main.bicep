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

@description('Resource Variables')
var _vnetSpokeName_ = 'vnet-spoke-prod'
var _vnetSpokeAddrSpace_ = '10.151.0.0/22'
var _publicIpAddressName_ = 'pip-bastion-vnet-spoke-prod'
var _bastionHostName_ = 'bas-vnet-spoke-prod'
var _storageAccountName_ = 'sabasrecordingsprod'
var _blobContainerName_ = 'bastion-recordings'
var _keyVaultName_ = 'kv-ct-nw-prod'
var _nacRgName_ = 'rg-networking-${__env__}'

resource nacRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name:_nacRgName_
  location:  __location__
  tags: _tags_
}

module sln './modules/nac.bicep' = {
  name: 'module-bastion-demo-deployment'
  params: {
    __location__: __location__
    _tags_: _tags_
    _vnetSpokeName_: _vnetSpokeName_
    _vnetSpokeAddrSpace_: _vnetSpokeAddrSpace_
    _publicIpAddressName_: _publicIpAddressName_
    _bastionHostName_: _bastionHostName_
    _storageAccountName_: _storageAccountName_
    _blobContainerName_: _blobContainerName_
    _keyVaultName_: _keyVaultName_
  }
  scope: nacRg
}
