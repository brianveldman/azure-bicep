metadata name = 'pimRoleAssignment'
metadata description = 'Bicep template for PIM role assignments'
metadata owner = 'Brian Veldman'
metadata versionnumber = '1.0.0'

targetScope = 'subscription'

@description('Array of PIM roles to assign')
param __pimRoles__ object = {
  Contributor: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
}

@description('Duration for the role eligibility schedule request')
param __duration__ string = 'P90D'

@description('Start date and time for the role eligibility schedule request')
param __startDateTime__ string = utcNow()

@description('Principal ID for the role eligibility schedule request - Define the User ID / Group ID / Service Principal ID')
param __principalId__ string = '5d16739a-d7ad-4c43-86d3-e06a37a9a90b'

@description('Contributor - Role eligibility schedule request')
resource pim 'Microsoft.Authorization/roleEligibilityScheduleRequests@2022-04-01-preview' = { 
  name: guid(subscription().subscriptionId, 'roleEligibilityScheduleRequest')
  scope: subscription()
  properties: {
    principalId: __principalId__
    requestType: 'AdminAssign'
    roleDefinitionId: __pimRoles__.Contributor
    scheduleInfo: {
      expiration: {
        duration: __duration__
        type: 'AfterDuration'
      }

      startDateTime: __startDateTime__
    }
  }
}
