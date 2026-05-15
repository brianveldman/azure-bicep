  metadata name = 'Azure Backup and Resource Guard Deployment'
  metadata description = 'Deploys Azure Backup and Resource Guard'
  metadata owner = 'Brian Veldman'
  metadata version = '1.0.0'
  targetScope = 'subscription'

  @description('Defing our input parameters')
  param __env__ string
  param __alzName__ string 
  param __location__ string
  param __shortLocation__ string = substring(__location__, 0, 6)

  @description('Defining our variables')
  var _bcResourceGroupName_ = 'rg-${__alzName__}-backup-${__env__}-${__shortLocation__}-001'
  var _backupResourceName_ = 'rsv-${__alzName__}-${__env__}-${__shortLocation__}-001'
  var _resourceGuardName_ = 'guard-${__alzName__}-${__env__}-${__shortLocation__}-001'

  @description('Resource Group Deployment')
  resource bcResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
    name: _bcResourceGroupName_
    location: __location__
  }

  @description('Module Deployment')
  module modBackup './modules/backup.bicep' = {
    name: 'module-backup-deployment'
    params: {
      __location__: __location__
      _backupResourceName_: _backupResourceName_
      _resourceGuardName_: _resourceGuardName_
    }
    scope: bcResourceGroup
  }
