targetScope = 'subscription'

param __location__ string = 'westeurope'
param __env__ string = 'prod'

var _acsResourceGroupName_ = 'rg-acs-${__env__}'
var _acsEmailServiceName_ = 'acs-cloudtips-${__env__}'
var _acsServiceName_ = 'cs-cloudtips-${__env__}'
var _acsDataLocation_ = 'Europe'


resource acsResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: _acsResourceGroupName_
  location: __location__
}


module acsModule './modules/acs.bicep' = {
  name: 'deployment-acsmodule-${__env__}'
  params: {
    _acsEmailServiceName_: _acsEmailServiceName_
    _acsServiceName_: _acsServiceName_
    _acsDataLocation_: _acsDataLocation_
  }
  scope: acsResourceGroup
}
