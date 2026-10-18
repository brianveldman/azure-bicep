param parLocation string = 'germanywestcentral'
param principalId string = deployer().objectId

resource storage 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: 'st${uniqueString(resourceGroup().id)}'
  location: parLocation
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

@retryOn(['ResourceNotFound'], 5)
resource blobContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storage.id, principalId, subscription().id)
  scope: storage
  properties: {
    roleDefinitionId: roleDefinitions('Storage Blob Data Contributor').id
    principalId: principalId
    principalType: 'User'
  }
}
