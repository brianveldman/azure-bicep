targetScope = 'tenant'

@description('Defining our input parameters')
param parWorkloadsSubscriptionId string = 'workloadsSubscriptionId'
param storageAccountName string = 'stwlpaymentsprodweu001'
param parName string = 'payments'
param parEnvironment string = 'prod'

@description('Deployment of Azure Service Group')
resource serviceGroup 'Microsoft.Management/serviceGroups@2024-02-01-preview' = {
  name: 'sg-${parName}-${parEnvironment}'
  properties: {
    displayName: 'Service Group ${parName} for ${parEnvironment}'
    parent: {
      resourceId: '/providers/Microsoft.Management/serviceGroups/${tenant().tenantId}'
    }
  }
}

@description('Deployment of Azure Service Group Relationship between subscription and storage account')
module relationshipModule 'modules/relationship.bicep' = {
  scope: resourceGroup(parWorkloadsSubscriptionId, 'rg-wl-payments-prod-westeu-001')
  params: {
    storageAccountName: storageAccountName
    serviceGroupId: serviceGroup.id
  }
}
