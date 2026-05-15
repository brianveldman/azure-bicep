targetScope = 'resourceGroup'

param storageAccountName string
param serviceGroupId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' existing = {
  name: storageAccountName
}

resource relationShip 'Microsoft.Relationships/serviceGroupMember@2023-09-01-preview' = {
  scope: storageAccount
  name: guid(storageAccount.id, serviceGroupId)
  properties: {
    targetId: serviceGroupId
  }
}
