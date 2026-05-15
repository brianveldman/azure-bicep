targetScope = 'tenant'

param __tenantId__ string = tenant().tenantId
param __rootManagementGroupName__ string
param __rootLandingZone__ array
param __midManagementGroups__ array
param __platformLandingZones__ array
param __LandingZones__ array

@description('A management group for main resources')
resource rootManagementGroup 'Microsoft.Management/managementGroups@2023-04-01' = [for managementGroups in __rootLandingZone__: {
  name: managementGroups.id
  properties: {
    details: {
      parent: {
        id: tenantResourceId('Microsoft.Management/managementGroups', __tenantId__)
      }
    }
  }
}]

@description('Deployment mid Management Groups')
resource midManagementGroups 'Microsoft.Management/managementGroups@2023-04-01' = [for managementGroups in __midManagementGroups__:  {
  name: managementGroups.id
  properties: {
    details: {
      parent: {
        id: tenantResourceId('Microsoft.Management/managementGroups',managementGroups.parentId)
      }
    }
  }
  dependsOn: [
    rootManagementGroup
  ]
}]


@description('Deployment Platform Management Groups')
resource platformLandingZoneManagementGroups 'Microsoft.Management/managementGroups@2023-04-01' = [for managementGroups in __platformLandingZones__:  {
  name: managementGroups.id
  properties: {
    details: {
      parent: {
        id: tenantResourceId('Microsoft.Management/managementGroups',managementGroups.parentId)
      }
    }
  }
  dependsOn: [
    midManagementGroups
  ]
}]

@description('Deployment Landing Zone Management Groups')
resource LandingZoneManagementGroups 'Microsoft.Management/managementGroups@2023-04-01' = [for managementGroups in __LandingZones__:  {
  name: managementGroups.id
  properties: {
    details: {
      parent: {
        id: tenantResourceId('Microsoft.Management/managementGroups',managementGroups.parentId)
      }
    }
  }
  dependsOn: [
    platformLandingZoneManagementGroups
  ]
}]
