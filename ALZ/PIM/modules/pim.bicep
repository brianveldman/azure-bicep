targetScope = 'subscription'

param parDuration string
param groupId string
param roleDefinitionId string
param startDateTime string = utcNow()

resource pimRequest 'Microsoft.Authorization/roleEligibilityScheduleRequests@2022-04-01-preview' = { //@2022-04-01-preview worked
  name: guid(subscription().id, 'roleEligibilityScheduleRequest', groupId, roleDefinitionId)
  scope: subscription()
  properties: {
    principalId: groupId
    requestType: 'AdminAssign'
    roleDefinitionId: roleDefinitionId
    scheduleInfo: {
      startDateTime: startDateTime
      expiration: {
        duration: parDuration
        type: 'AfterDuration'
      }
    }
  }
}
