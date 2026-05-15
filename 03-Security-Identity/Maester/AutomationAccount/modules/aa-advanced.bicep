extension microsoftGraphV1
param __location__ string
param __maesterAppRoles__ array
param __maesterAutomationAccountModules__ array
param __ouMaesterAutomationMiId__ string
param __ouMaesterScriptBlobUri__ string
param _maesterAutomationAccountName_ string
param __currentUtcTime__ string = utcNow()

@description('Role Assignment Deployment')
resource graphId 'Microsoft.Graph/servicePrincipals@v1.0' existing = {
  appId: '00000003-0000-0000-c000-000000000000'
}

resource managedIdentityRoleAssignment 'Microsoft.Graph/appRoleAssignedTo@v1.0' = [for appRole in __maesterAppRoles__: {
    appRoleId: (filter(graphId.appRoles, role => role.value == appRole)[0]).id
    principalId: __ouMaesterAutomationMiId__
    resourceId: graphId.id
}]

@description('Existing Automation Account')
resource automationAccount 'Microsoft.Automation/automationAccounts@2023-11-01' existing = {
  name: _maesterAutomationAccountName_
}

@description('PowerShell Modules Deployment')
resource automationAccountModules 'Microsoft.Automation/automationAccounts/modules@2023-11-01' = [ for module in __maesterAutomationAccountModules__: {
  name: module.name
  parent: automationAccount
  properties: {
    contentLink: {
      uri: module.uri
    }
  }
}]

@description('Runbook Deployment')
resource automationAccountRunbook 'Microsoft.Automation/automationAccounts/runbooks@2023-11-01' = {
  name: 'runBookMaester'
  location: __location__
  parent: automationAccount
  properties: {
    runbookType: 'PowerShell'
    logProgress: true
    logVerbose: true
    description: 'Runbook to execute Maester report'
    publishContentLink: {
      uri: __ouMaesterScriptBlobUri__
    }
  }
}

@description('Schedule Deployment')
resource automationAccountSchedule 'Microsoft.Automation/automationAccounts/schedules@2023-11-01' = {
  name: 'scheduleMaester'
  parent: automationAccount
  properties: {
    expiryTime: '9999-12-31T23:59:59.9999999+00:00'
    frequency: 'Month'
    interval: 1
    startTime: dateTimeAdd(__currentUtcTime__, 'PT1H')
    timeZone: 'W. Europe Standard Time'
  }
}

@description('Runbook Schedule Association')
resource maesterRunbookSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2023-11-01' = {
  name: guid(automationAccount.id, 'runbook', 'schedule')
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
