metadata name = 'Azure SRE Deployment'
metadata description = 'Deploys Azure SRE resources'
metadata owner = 'Brian Veldman'
metadata version = '1.0.0'

targetScope = 'resourceGroup'

@description('Solution name for resource naming')
param parSolution string = 'infra'

@description('Deployment environment')
param parEnvironment string = 'prod'

@description('Deployment number for uniqueness')
param parDeploymentNumber string = '001'

@description('Deployment location')
@allowed([
  'eastus2'
  'swedencentral'
  'australiaeast'
])
param parLocation string = 'swedencentral'

@description('Model provider')
param parDefaultModelProvider string = 'Anthropic'

@description('User object id')
param parUserObjectId string = deployer().objectId

@allowed([
  'Low'
  'Medium'
  'High'
])
param parAccessLevel string = 'Low'

@description('Defining our variables')
var varShortEnvironmentMapping = {
  swedencentral: 'swc'
  eastus2: 'eus2'
  australiaeast: 'aue'
}
var varShortEnvironment = varShortEnvironmentMapping[parLocation] ?? parLocation

@description('Deploy Log Analytics Workspace')
resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'log-${parSolution}-${parEnvironment}-${varShortEnvironment}-${parDeploymentNumber}'
  location: parLocation
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

@description('Deploy Application Insights')
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-${parSolution}-${parEnvironment}-${varShortEnvironment}-${parDeploymentNumber}'
  location: parLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'SreAgent'
    WorkspaceResourceId: workspace.id
  }
}

@description('User assigned identity for the agent')
resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: 'id-${parSolution}-${parEnvironment}-${varShortEnvironment}-${parDeploymentNumber}'
  location: parLocation
}

@description('Deploy SRE Agent')
#disable-next-line BCP081
resource agent 'Microsoft.App/agents@2025-05-01-preview' = {
  name: 'sre-${parSolution}-${parEnvironment}-${varShortEnvironment}-${parDeploymentNumber}'
  location: parLocation
  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${identity.id}': {}
    }
  }
  properties: {
    knowledgeGraphConfiguration: {
      managedResources: []
      identity: identity.id
    }
    actionConfiguration: {
      mode: 'review'
      identity: identity.id
      accessLevel: parAccessLevel
    }
    logConfiguration: {
      applicationInsightsConfiguration: {
        appId: appInsights.properties.AppId
        connectionString: appInsights.properties.ConnectionString
      }
    }
    defaultModel: {
      provider: parDefaultModelProvider
      name: 'Automatic'
    }
  }
}

@description('Assign SRE Agent Administrator role to the user at agent scope')
resource agentAdminRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(agent.id, parAccessLevel, 'agent-admin')
  scope: agent
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'e79298df-d852-4c6d-84f9-5d13249d1e55')
    principalId: parUserObjectId
    principalType: 'User'
  }
}
