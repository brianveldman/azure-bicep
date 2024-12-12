
targetScope = 'subscription'

@description('Defining our input parameters')
param __env__ string
param __location__ string
param __solution__ string
param __ipAddressPrefixes__ array
param __subscriptionIds__ array

@description('Defining our variables')
var _nspName_ = 'nsp-networking-${__env__}'
var _nspLawName_ = 'nsp-law-${__env__}'
var _nspProfileName_ = 'nsp-p-${__solution__}-${__env__}'

@description('Defining our resource group')
resource networkingResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-networking-${__env__}'
  location: __location__
}

@description('Defing our modules as part of our Bicep deployment')
module modNsp './modules/nsp.bicep' = {
  name: 'nsp-module-deployment'
  params: {
    __location__: __location__
    __ipAddressPrefixes__: __ipAddressPrefixes__
    __subscriptionIds__: __subscriptionIds__
    _nspName_: _nspName_
    _nspLawName_: _nspLawName_
    _nspProfileName_: _nspProfileName_
  }
  scope: networkingResourceGroup
}
