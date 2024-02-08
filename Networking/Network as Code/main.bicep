metadata name = 'Networking as Code (NaC), VNets & Firewalls <3'
metadata description = 'This Bicep code deploys Networking as Code, including Hub & Spoke VNet, with peerings and Azure Firewall'
metadata owner = 'Brian Veldman'
targetScope = 'subscription'

@description('Main Parameters')
param __location__ string = 'westeurope'
param __env__ string = 'prod'
param __cust__ string = 'ct'
param __startDate__ string = utcNow('d-M-yyyy')
param __author__ string = 'Brian Veldman'
param __website__ string = 'CloudTips.nl'

@description('Decide if you want to enable logging for Azure Firewall')
param __loggingEnabled__ bool = true
//Caution currently you cannot deploy vgw to West Europe because of capacity issues :/
param __vgwEnabled__ bool = false

@description('Tagging Variables')
var _tags_ = {
  createdBy: __author__
  website: __website__
  environment: __env__
  startDate: __startDate__
}

@description('Networking Variables')
var _vnetHubName_ = 'vnet-hub-${__env__}'
var _vnetHubAddrSpace_ = '10.150.0.0/23'
var _vnetHubSubnetCount_ = 3
var _vnetSpokeName_ = 'vnet-spoke-${__env__}'
var _vnetSpokeAddrSpace_ = '10.151.0.0/22'
var _vnetSpokeSubnetCount_ = 4
var _routeTable_ = 'rt-${__cust__}-${__env__}'

@description('Network Gateway Variables')
var _vgwName_ = 'vgw-${__cust__}-${__env__}'
var _vgwPipName_ = 'pip-vgw-${__cust__}-${__env__}'

@description('Firewall Variables')
var _afwName_ = 'afw-${__cust__}-${__env__}'
var _afwPipName_ = 'pip-afw-${__cust__}-${__env__}'
var _afwMgmtPipName_ = 'mgmt-pip-afw-${__cust__}-${__env__}'
var _afwpName_ = 'afwp-${__cust__}-${__env__}'
var _nacRgName_ = 'rg-networking-${__env__}'

@description('Logging Variables')
var _lawName_ = 'law-networking-${__env__}'

resource nacRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name:_nacRgName_
  location:  __location__
  tags: _tags_
}

module nac './modules/nac.bicep' = {
  name: 'module-vnet-deployment'
  params: {
    __location__: __location__
    _tags_: _tags_
    _vnetHubName_: _vnetHubName_
    _vnetHubAddrSpace_: _vnetHubAddrSpace_
    _vnetHubSubnetCount_:  _vnetHubSubnetCount_
    _vnetSpokeName_: _vnetSpokeName_
    _vnetSpokeAddrSpace_: _vnetSpokeAddrSpace_
    _vnetSpokeSubnetCount_: _vnetSpokeSubnetCount_
    _routeTable_: _routeTable_
    _vgwName_: _vgwName_
    _vgwPipName_: _vgwPipName_
    __vgwEnabled__:  __vgwEnabled__
  }
  scope: nacRg
}

module afw './modules/afw.bicep' = {
  name: 'module-afw-deployment'
  params: {
    __location__: __location__
    _tags_: _tags_
    _afwName_: _afwName_
    _afwPipName_: _afwPipName_
    _afwMgmtPipName_: _afwMgmtPipName_
    _afwpName_: _afwpName_
    __loggingEnabled__: __loggingEnabled__
    _lawName_: _lawName_
    afwSubnet: nac.outputs.afwSubnet
    afwMgmtSubnet: nac.outputs.afwMgmtSubnet
  }
  scope: nacRg
}
