param parEnvironment string
param parLocation string 
param parAlzName string
param shortEnvironment string

@description('Deployment of Foundry')
resource aif 'Microsoft.CognitiveServices/accounts@2025-12-01' = {
  name: 'aif-${parAlzName}-${parEnvironment}-${shortEnvironment}-001'
  location: parLocation
  kind: 'AIServices'
  sku: {
    name: 'S0'
  }
  properties: {
    allowProjectManagement: true
    customSubDomainName: 'sub-aif-${parAlzName}-${parEnvironment}-${shortEnvironment}-001'
  }
}

@description('Deployment of Foundry Project')
resource aip 'Microsoft.CognitiveServices/accounts/projects@2025-12-01' = {
  name: 'proj-aif-${parAlzName}-${parEnvironment}-${shortEnvironment}-001'
  parent: aif
  location: parLocation
  identity: {
    type: 'SystemAssigned'
  }
}

@description('Deployment of Foundry Model Router')
resource router 'Microsoft.CognitiveServices/accounts/deployments@2025-12-01' = {
  name: 'model-router'
  parent: aif
  sku: {
    name:  'GlobalStandard'
    capacity: 499 //1 capacity unit = 1000 tokens per minute, took the standard capacity
  }
  properties: {
    model: {
      name: 'model-router'
      format: 'OpenAI'
      version: '2025-11-18' // Last supported version
      
    }
    routing: {
      mode: 'balanced'
    }
  }
}
