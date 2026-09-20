param parLocation string
param parEnvironment string
param parLandingZone string
param parNumber string

@description('Defining our variables')
var varShortLocationName = substring(parLocation, 0, 6)
var varStName = 'st${parEnvironment}${parLandingZone}${varShortLocationName}${parNumber}'
var varShareName = 'scripts'
var varLogName = 'log-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
var varAppiName = 'appi-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
var varCaeName = 'cae-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
var varCajName = 'caj-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'

@description('Deployment of Azure Storage Account for saving our scripts')
module st 'br/public:avm/res/storage/storage-account:0.27.1' = {
  name: 'mod-st-${deployment().name}'
  params: {
    name: varStName
    location: parLocation
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    fileServices: {
      shares: [
        {
          name: varShareName
          enabledProtocols: 'SMB'
          shareQuota: 10 //Explict set otherwise 5TB
        }
      ]
    }
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
}
@description('Deployment of Azure Log Analytics Workspace')
module log 'br/public:avm/res/operational-insights/workspace:0.12.0' = {
  name: 'mod-log-${deployment().name}'
  params: {
    name: varLogName
    location: parLocation
  }
}

@description('Deployment of Azure App Insights')
module appi 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'mod-appi-${deployment().name}'
  params: {
    name: varAppiName
    location: parLocation
    workspaceResourceId: log.outputs.resourceId
    applicationType: 'web'
  }
}

@description('Deployment of Azure Container App Environment')
module cae 'br/public:avm/res/app/managed-environment:0.11.3' = {
  name: 'mod-cae-deployment'
  params: {
    name: varCaeName
    location: parLocation
    appInsightsConnectionString: appi.outputs.connectionString
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: log.outputs.logAnalyticsWorkspaceId
        sharedKey: log.outputs.primarySharedKey
      }
    }
    storages: [
      {
        kind: 'SMB'
        accessMode: 'ReadWrite'
        shareName: varShareName
        storageAccountName: varStName
      }
    ]
    zoneRedundant: false
    publicNetworkAccess: 'Enabled'
  }
}

@description('Deployment of Azure Container App Job')
module caj 'br/public:avm/res/app/job:0.7.1' = {
  name: 'mod-caj-deployment'
  params: {
    name: varCajName
    triggerType: 'Schedule'
    scheduleTriggerConfig: {
      cronExpression: '30 9 * * *' //Run every day at 9:30 
    }
    location: parLocation
    environmentResourceId: cae.outputs.resourceId
    volumes: [
      {
        name: 'azure-files-volume'
        storageName: varShareName
        storageType: 'AzureFile'
      }
    ]
    managedIdentities: {
      systemAssigned: true
    }
    containers: [
      {
        name: 'alz-aca-job'
        resources: {
          cpu: '0.25'
          memory: '0.5Gi'
        }
        image: 'mcr.microsoft.com/azure-powershell:latest'
        volumeMounts: [
          {
            mountPath: '/scripts'
            volumeName: 'azure-files-volume'
          }
        ]
        command: [
          'pwsh'
        ]
        args: [
          '-File'
          '/scripts/readChanges.ps1'
        ]
      }
    ]
  }
}

@description('Existing Storage Account Resource')
resource sa 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: varStName
}

@description('Role assignment: Container App Job MI -> Azure Files share Contributor')
resource raShare 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: sa
  name: guid(subscription().subscriptionId, '0c867c2a-1d8c-454a-a3db-ab2ea1bdc8bb')
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      // Storage File Data SMB Share Contributor
      '0c867c2a-1d8c-454a-a3db-ab2ea1bdc8bb'
    )
    principalId: caj.outputs.?systemAssignedMIPrincipalId ?? ''
    principalType: 'ServicePrincipal'
  }
}

output caMiPrincipalId string = caj.outputs.?systemAssignedMIPrincipalId ?? ''
