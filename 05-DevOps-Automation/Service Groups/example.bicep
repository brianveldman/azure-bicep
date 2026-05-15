targetScope = 'tenant'

@description('Defining our input parameters')
param parManagementSubscriptionId string = 'managementSubscriptionId'
param parWorkloadsSubscriptionId string = 'workloadsSubscriptionId'
param parWorkloadsResourceGroupName string = 'rg-wl-payments-prod-westeu-001'
param parName string = 'payments'
param parEnvironment string = 'prod'

@description('Deployment of Azure Service Group')
module serviceGroup 'br/public:avm/res/management/service-group:0.1.1' = {
  params: {
    name: 'sg-${parName}-${parEnvironment}'
    displayName: 'Service Group ${parName} for ${parEnvironment}'
    subscriptionIdsToAssociateToServiceGroup: [
      parManagementSubscriptionId
    ]
    resourceGroupResourceIdsToAssociateToServiceGroup: [
      '/subscriptions/${parWorkloadsSubscriptionId}/resourceGroups/${parWorkloadsResourceGroupName}'
    ]
  }
}
