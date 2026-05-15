param __location__ string
param _azTags_ object

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'name'
  location: __location__
  tags: _azTags_
  kind: 'StorageV2'
  sku: {
    name: 'Standard_GRS'
  }
  properties: {
    allowBlobPublicAccess: true
    supportsHttpsTrafficOnly: false
  }
}
