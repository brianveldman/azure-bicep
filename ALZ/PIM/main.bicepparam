using 'main.bicep'

param parDuration = 'P365D'

param parManagementSubscriptionId = ''
param parSecuritySubscriptionId = ''
param parConnectivitySubscriptionId = ''
param parIdentitySubscriptionId = ''

param parLandingZoneGroups  = [
  {
    displayName: 'sg-alz-management-contributors-prod'
    mailNickname: 'sg-alz-management-contributors-prod'
    uniqueName: 'sg-alz-management-contributors-prod'
    roleDefinitionId: '/subscriptions/${parManagementSubscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    subscriptionId: parManagementSubscriptionId
  }
  {
    displayName: 'sg-alz-management-readers-prod'
    mailNickname: 'sg-alz-management-readers-prod'
    uniqueName: 'sg-alz-management-readers-prod'
    roleDefinitionId: '/subscriptions/${parManagementSubscriptionId}/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
    subscriptionId: parManagementSubscriptionId
  }
  {
    displayName: 'sg-alz-security-contributors-prod'
    mailNickname: 'sg-alz-security-contributors-prod'
    uniqueName: 'sg-alz-security-contributors-prod'
    roleDefinitionId: '/subscriptions/${parSecuritySubscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    subscriptionId: parSecuritySubscriptionId
  }
  {
    displayName: 'sg-alz-security-readers-prod'
    mailNickname: 'sg-alz-security-readers-prod'
    uniqueName: 'sg-alz-security-readers-prod'
    roleDefinitionId: '/subscriptions/${parSecuritySubscriptionId}/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
    subscriptionId: parSecuritySubscriptionId
  }
  {
    displayName: 'sg-alz-connectivity-contributors-prod'
    mailNickname: 'sg-alz-connectivity-contributors-prod'
    uniqueName: 'sg-alz-connectivity-contributors-prod'
    roleDefinitionId: '/subscriptions/${parConnectivitySubscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    subscriptionId: parConnectivitySubscriptionId
  }
  {
    displayName: 'sg-alz-connectivity-readers-prod'
    mailNickname: 'sg-alz-connectivity-readers-prod'
    uniqueName: 'sg-alz-connectivity-readers-prod'
    roleDefinitionId: '/subscriptions/${parConnectivitySubscriptionId}/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
    subscriptionId: parConnectivitySubscriptionId
  }
  {
    displayName: 'sg-alz-identity-contributors-prod'
    mailNickname: 'sg-alz-identity-contributors-prod'
    uniqueName: 'sg-alz-identity-contributors-prod'
    roleDefinitionId: '/subscriptions/${parIdentitySubscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    subscriptionId: parIdentitySubscriptionId
  }
  {
    displayName: 'sg-alz-identity-readers-prod'
    mailNickname: 'sg-alz-identity-readers-prod'
    uniqueName: 'sg-alz-identity-readers-prod'
    roleDefinitionId: '/subscriptions/${parIdentitySubscriptionId}/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
    subscriptionId: parIdentitySubscriptionId
  }
]
