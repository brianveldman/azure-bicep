extension microsoftGraphV1
param __location__ string
param __maesterAppRoles__ array

param __ouMaesterAutomationMiId__ string
param __ouMaesterScriptBlobUri__ string
param _maesterAutomationAccountName_ string
param __currentUtcTime__ string = utcNow()

@description('Microsoft Graph - Role Assignment Deployment')
resource graphId 'Microsoft.Graph/servicePrincipals@v1.0' existing = {
  appId: '00000003-0000-0000-c000-000000000000'
}

@description('Exchange - Role Assignment Deployment')
resource exchangeOnlineId 'Microsoft.Graph/servicePrincipals@v1.0' existing =  {
  appId: '00000002-0000-0ff1-ce00-000000000000'
}

resource managedIdentityRoleAssignment 'Microsoft.Graph/appRoleAssignedTo@v1.0' = [for appRole in __maesterAppRoles__: {
    appRoleId: (filter(graphId.appRoles, role => role.value == appRole)[0]).id
    principalId: __ouMaesterAutomationMiId__
    resourceId: graphId.id
}]

resource managedIdentityRoleAssignmentExchange 'Microsoft.Graph/appRoleAssignedTo@v1.0' =  {
  appRoleId: (filter(exchangeOnlineId.appRoles, role => role.value == 'Exchange.ManageAsApp')[0]).id
  principalId: __ouMaesterAutomationMiId__
  resourceId: exchangeOnlineId.id
}

@description('Existing Automation Account')
resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' existing = {
  name: _maesterAutomationAccountName_
}

@description('Runbook Deployment')
resource automationAccountRunbook 'Microsoft.Automation/automationAccounts/runbooks@2024-10-23' = {
  name: 'runBookMaester'
  location: __location__
  parent: automationAccount
  properties: {
    runbookType: 'PowerShell'
    runtimeEnvironment: 'PowerShell-7.4'
    logProgress: true
    logVerbose: true
    description: 'Runbook to execute Maester report'
    publishContentLink: {
      uri: __ouMaesterScriptBlobUri__
    }
  }
}

@description('Schedule Deployment')
resource automationAccountSchedule 'Microsoft.Automation/automationAccounts/schedules@2024-10-23' = {
  name: 'scheduleMaester'
  parent: automationAccount
  properties: {
    advancedSchedule: {
      weekDays:[
        'Monday'
        'Wednesday'
        'Friday'
      ]
    }
    expiryTime: '9999-12-31T23:59:59.9999999+00:00'
    frequency: 'Week'
    interval: 1
    startTime: dateTimeAdd(__currentUtcTime__, 'PT1H')
    timeZone: 'W. Europe Standard Time'
  }
}

@description('Runbook Schedule Association')
resource maesterRunbookSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2024-10-23' = {
  name: guid(automationAccount.id, automationAccountRunbook.name, automationAccount.name)
  parent: automationAccount
  properties: {
    parameters: {}
    runbook: {
      name: automationAccountRunbook.name
    }
    schedule: {
      name: automationAccountSchedule.name
    }
  }
}
