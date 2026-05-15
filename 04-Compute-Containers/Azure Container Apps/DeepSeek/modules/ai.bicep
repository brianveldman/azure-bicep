param parEnvironmentName string 
param parLocation string
param parSolutionName string 
param parContainerEnvironmentName string
param parLogAnalyticsName string
param parContainerName string 

@description('Deployment of Azure Log Analytics Workspace')
resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: parLogAnalyticsName
  location: parLocation
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

@description('Deployment of Azure Container Apps Environment')
resource environment 'Microsoft.App/managedEnvironments@2024-10-02-preview' = {
  name: parContainerEnvironmentName
  location: parLocation
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: workspace.properties.customerId
        sharedKey: workspace.listKeys().primarySharedKey
      }
    }
    publicNetworkAccess: 'Enabled'
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
      {
        name: 'NC8as-T4'
        workloadProfileType: 'Consumption-GPU-NC8as-T4'
      }
    ]
  }
}

@description('Deployment of Azure Container Apps')
resource container 'Microsoft.App/containerApps@2024-10-02-preview' = {
  name: parContainerName
  kind: 'containerApp'
  location: parLocation
  properties: {
    environmentId: environment.id
    configuration: {
      activeRevisionsMode: 'Single'
      ingress: {
        external: true
        transport: 'auto'
        allowInsecure: false
        targetPort: 8080
        stickySessions: {
          affinity: 'none'
        }
        additionalPortMappings: []
      } 
    }
    template: {
      scale: {
        minReplicas: 0
      }
      containers: [{
        name: 'deepseekr1'
        image: 'ghcr.io/open-webui/open-webui:ollama'
        command: []
        args: []
        resources: {
          cpu: 8
          memory: '56Gi'
        }
      }
    ]

    }
    workloadProfileName: 'NC8as-T4'    
  }
}
