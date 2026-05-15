targetScope = 'subscription'

@description('Defining our Parameters')
param parExistingVirtualNetworkName string
param parExistingVirtualNetworkResourceGroupName string
param parEnvironmentName string
param parApplicationName string
param parNumber string
param parLocation string

@description('Defining our Variables')
var varShortEnvironmentMapping = {
  westeurope: 'weu'
  northeurope: 'neu'
  germanywestcentral: 'dewc'
  canadacentral: 'cac'
  australiaeast: 'eau'
}

var varShortEnvironment = varShortEnvironmentMapping[parLocation] ?? parLocation
var varResourceGroupName = 'rg-aca-${parApplicationName}-${parEnvironmentName}-${varShortEnvironment}-${parNumber}'
var varContainerEnvironmentName = 'cae-${parApplicationName}-${parEnvironmentName}-${varShortEnvironment}-${parNumber}'
var varLogAnalyticsName = 'law-${parApplicationName}-${parEnvironmentName}-${varShortEnvironment}-${parNumber}'
var varAppInsightsName = 'appi-${parApplicationName}-${parEnvironmentName}-${varShortEnvironment}-${parNumber}'
var varContainerRegistryName = 'cr${parApplicationName}${parEnvironmentName}${varShortEnvironment}${parNumber}'
var varContainerName = 'ca-${parApplicationName}-${parEnvironmentName}-${varShortEnvironment}-${parNumber}'
var varSolutionName = '${parApplicationName}-${parApplicationName}-${parEnvironmentName}-${varShortEnvironment}-${parNumber}'

@description('Deployment of Azure Resource Group')
module rg 'br/public:avm/res/resources/resource-group:0.4.3' = {
  params: {
    name: varResourceGroupName
  }
}

@description('Deployment of Azure Log Analytics Workspace')
module workspace 'br/public:avm/res/operational-insights/workspace:0.15.0' = {
  params: {
    name: varLogAnalyticsName
    location: parLocation
    dailyQuotaGb: '1'
    dataRetention: 30
  }
  dependsOn: [
    rg
  ]
  scope: resourceGroup(varResourceGroupName)
}

@description('Deployment of Azure App Insights')
module appi 'br/public:avm/res/insights/component:0.7.1' = {
  params: {
    name: varAppInsightsName
    workspaceResourceId: workspace.outputs.resourceId
    applicationType: 'web'
  }
  dependsOn: [
    rg
  ]
  scope: resourceGroup(varResourceGroupName)
}

@description('Deployment of Azure Container Registry')
module registry 'br/public:avm/res/container-registry/registry:0.9.3' = {
  params: {
    name: varContainerRegistryName
    acrSku: 'Basic'
    location: parLocation
  }
  dependsOn: [
    rg
  ]
  scope: resourceGroup(varResourceGroupName)
}

@description('Retrieving existing Virtual Network for Private Endpoint')
resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' existing = {
  name: parExistingVirtualNetworkName
  scope: resourceGroup(parExistingVirtualNetworkResourceGroupName)
}

@description('Deployment of Azure Container Apps Environment')
module ace 'br/public:avm/res/app/managed-environment:0.11.3' = {
  params: {
    name: varContainerEnvironmentName
    location: parLocation
    internal: true
    infrastructureSubnetResourceId: vnet.properties.subnets[0].id
    appInsightsConnectionString: appi.outputs.resourceId
    zoneRedundant: false
    publicNetworkAccess: 'Disabled'
    workloadProfiles: [
      {
        name: 'Flex'
        workloadProfileType: 'Flex'
      }
    ]
  }
  dependsOn: [
    rg
  ]
  scope: resourceGroup(varResourceGroupName)
}

@description('Deployment of Azure Container App')
module app 'br/public:avm/res/app/container-app:0.20.0' = {
  params: {
    name: varContainerName
    scaleSettings: {
      minReplicas: 1
      maxReplicas: 2
    }
    containers: [
      {
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: toLower(varSolutionName)
        resources: {
          cpu: json('.25')
          memory: '1.0Gi'
        }
      }
    ]
    managedIdentities: {
      systemAssigned: true
    }
    environmentResourceId: ace.outputs.resourceId
    workloadProfileName: 'Flex'
  }
  dependsOn: [
    rg
  ]
  scope: resourceGroup(varResourceGroupName)
}
