param __location__ string
param _vnetName_ string
param __deployerObjectId__ string

@description('Creation simple VNET')
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: _vnetName_
  location: __location__
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.30.0/23'
      ]
    }
    subnets: [
      {
        name: 'snet-workloads'
        properties: {
          addressPrefix: '10.20.30.0/24'
        }
      }
    ]
  }
}

@description('RBAC assignment contributor on VNet resource')
resource networkContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: virtualNetwork
  name: guid(virtualNetwork.id, 'Network Contributor', __deployerObjectId__)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
    principalId: __deployerObjectId__
  }
}
