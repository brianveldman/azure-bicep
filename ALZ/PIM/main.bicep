metadata name = 'ALZ - Bicep - PIM Deployment'
metadata description = 'Bicep template for Azure Landing Zones PIM role assignments'
metadata owner = 'Brian Veldman'
metadata versionnumber = '1.0.0'

//////////////////////////////////
extension microsoftGraphV1
//////////////////////////////////

//////////////////////////////////
targetScope = 'subscription'
//////////////////////////////////
@description('Duration for the role eligibility schedule request')
param parDuration string

@description('Management SubscriptionId')
param parManagementSubscriptionId string

@description('Security SubscriptionId')
param parSecuritySubscriptionId string

@description('Connectivity SubscriptionId')
param parConnectivitySubscriptionId string

@description('Identity SubscriptionId')
param parIdentitySubscriptionId string

@description('Array of landing zone groups to create in Microsoft Graph')
param parLandingZoneGroups array

@description('Creation of Microsoft Graph for the Azure Landing Zones')
resource alzGroups 'Microsoft.Graph/groups@v1.0' = [for landingZoneGroup in parLandingZoneGroups: {
  displayName: landingZoneGroup.displayName
  mailEnabled: false
  mailNickname: landingZoneGroup.mailNickname
  securityEnabled: true
  uniqueName: landingZoneGroup.uniqueName
}]

@description('Module to create PIM role assignments for each landing zone group')
module pimModules './modules/pim.bicep' = [for (landingZoneGroup, i) in parLandingZoneGroups: {
  name: 'pim-${landingZoneGroup.uniqueName}'
  scope: subscription(landingZoneGroup.subscriptionId)
  params: {
    groupId: alzGroups[i].id
    roleDefinitionId: landingZoneGroup.roleDefinitionId
    parDuration: parDuration
  }
}]

@description('Outputs for subscription IDs')
output ouManagementSubscriptionId string = parManagementSubscriptionId
output ouSecuritySubscriptionId string = parSecuritySubscriptionId
output ouConnectivitySubscriptionId string = parConnectivitySubscriptionId
output ouIdentitySubscriptionId string = parIdentitySubscriptionId
