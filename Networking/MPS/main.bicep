metadata name = 'Networking as Code (NaC), Multiple Prefixes for a single subnet'
metadata description = 'This Bicep code deploys Networking as Code, 1 VNet with 1 subnet using 2 prefixes'
metadata owner = 'Brian Veldman'
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

@description('Networking Variables')
var _vnetHubName_ = 'vnet-hub-${__env__}'
var _vnetHubAddrSpace_ = '10.10.10.0/23'
var _nacRgName_ = 'rg-networking-${__env__}'

resource nacRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name:_nacRgName_
  location:  __location__
  tags: _tags_
}

module nac './modules/vnet.bicep' = {
  name: 'module-vnet-deployment'
  params: {
    __location__: __location__
    _vnetHubName_: _vnetHubName_
    _vnetHubAddrSpace_: _vnetHubAddrSpace_
  }
  scope: nacRg
}
