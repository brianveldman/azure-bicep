param __location__ string
param _maintenanceConfigurationName_ string
param __maintenanceSubScope__ string
param __maintenanceStartDateTime__ string
param __maintenanceDuration__ string
param __maintenanceTimeZone__ string

@description('Deployment of Azure Maintenance Configuration')
resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-10-01-preview' = {
  name: _maintenanceConfigurationName_
  location: __location__
  properties: {
    extensionProperties: {
      maintenanceSubScope: __maintenanceSubScope__
    }
    maintenanceScope: 'Resource'
    maintenanceWindow: {
      startDateTime: __maintenanceStartDateTime__
      duration: __maintenanceDuration__
      timeZone: __maintenanceTimeZone__
      recurEvery: '1Day' // Must be 1Day
    }
    visibility: 'Custom'
  }
}
