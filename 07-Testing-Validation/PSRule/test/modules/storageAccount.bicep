param __location__ string
param _storageAccountName_ string

@description('Deploying Storage Account')
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: _storageAccountName_
  location: __location__
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
  properties: {
    minimumTlsVersion: 'TLS1_0'
  }
}
