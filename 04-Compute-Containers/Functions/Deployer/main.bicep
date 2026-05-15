targetScope = 'subscription'

@description('Defining our input parameters')
param __location__ string = 'westeurope'
param __env__ string = 'prod'
param __deployerObjectId__ string = deployer().objectId

@description('Defining our vars')
var _deployerResourceGroupName_  = 'rg-deployer-${__env__}'
var _vnetName_ = 'vnet-${__env__}'
var _tags_ = {
  environment: __env__
  deployedBy: deployer().objectId
}

resource deployerRg 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: _deployerResourceGroupName_
  location: __location__
  tags: _tags_
}

module modVnet './modules/vnet.bicep' = {
  name: 'vnet-module-deployment'
  params: {
    __location__: __location__
    _vnetName_: _vnetName_
    __deployerObjectId__: __deployerObjectId__
  }
  scope: deployerRg
}
