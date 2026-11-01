param parLocation string
param parAlzName string
param parEnvironment string
param shortEnvironment string
param parDeploymentNumber string

@description('Deployment of Foundry')
resource aif 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: 'aif-${parAlzName}-${parEnvironment}-${shortEnvironment}-${parDeploymentNumber}'
  location: parLocation
  kind: 'AIServices'
  sku: {
    name: 'S0'
  }
  properties: {
    networkAcls: {
      defaultAction: 'Allow'
    }
    allowProjectManagement: true
    customSubDomainName: 'sub-aif-${parAlzName}-${parEnvironment}-${shortEnvironment}-${parDeploymentNumber}'
  }
}

@description('Deployment of Foundry Project')
resource aip 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' = {
  name: 'proj-aif-${parAlzName}-${parEnvironment}-${shortEnvironment}-${parDeploymentNumber}'
  parent: aif
  location: parLocation
  identity: {
    type: 'SystemAssigned'
  }
}

@description('Deployment of Foundry Model Router')
resource gptModel 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
  name: 'gpt-6-sol-deployment'
  parent: aif
  sku: {
    name: 'GlobalStandard'
    capacity: 499
  }
  properties: {
    model: {
      name: 'gpt-6-sol'
      format: 'OpenAI'
      version: '2026-09-22'
    }
  }
  dependsOn: [
    aip
  ]
}

@description('Deployment of Foundry Model Router')
resource grokModel 'Microsoft.CognitiveServices/accounts/deployments@2025-06-01' = {
  name: 'grok-4-7-deployment'
  parent: aif
  sku: {
    name: 'GlobalStandard'
    capacity: 499 
  }
  properties: {
    model: {
      name: 'grok-4.7'
      format: 'xAI'
      version: '1'
    }
  }
  dependsOn: [
    aip
  ]
}
