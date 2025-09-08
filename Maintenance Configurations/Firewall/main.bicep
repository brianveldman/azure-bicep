  metadata name = 'Azure Maintenance Configuration'
  metadata description = 'Deploys Azure Maintenance Configuration'
  metadata owner = 'Brian Veldman'
  metadata version = '1.0.0'
  targetScope = 'subscription'

  @description('Defing our input parameters')
  param __env__ string = 'prod'
  param __alzName__ string = 'management'
  param __location__ string = 'westeurope'

  @allowed([
  'NetworkGatewayMaintenance'
  'NetworkSecurity'
  ])
  param __maintenanceSubScope__ string = 'NetworkSecurity'
  param __maintenanceStartDateTime__ string = '2025-07-25 00:00'
  param __maintenanceDuration__ string = '05:00'
  param __maintenanceTimeZone__ string = 'W. Europe Standard Time'

  @description('Defining our variables')
  var _shortLocation_ = substring(__location__, 0, 6)
  var _mcResourceGroupName_ = 'rg-${__alzName__}-mc-${__env__}-${_shortLocation_}-001'
  var _maintenanceConfigurationName_ = 'mc-${__alzName__}-${__env__}-${_shortLocation_}-002'

  // @description('Resource Group Deployment')
  // resource mcResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  //   name: _mcResourceGroupName_
  //   location: __location__
  // }

  @description('Module Deployment')
  module modMc './modules/mc.bicep' = {
    name: 'module-mc-deployment'
    params: {
      __location__: __location__
      _maintenanceConfigurationName_: _maintenanceConfigurationName_
      __maintenanceSubScope__: __maintenanceSubScope__
      __maintenanceStartDateTime__: __maintenanceStartDateTime__
       __maintenanceDuration__: __maintenanceDuration__
      __maintenanceTimeZone__: __maintenanceTimeZone__
    }
    scope: resourceGroup(_mcResourceGroupName_)
  }
