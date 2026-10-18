param parLocation string = 'germanywestcentral'

@retryOn(['ResourceNotFound'], 5)
resource keyVault 'Microsoft.KeyVault/vaults@2024-12-01-preview' = {
  name: 'kv-test-ct'
  location: parLocation
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    accessPolicies: [
      {
        objectId: deployer().objectId
        permissions: {}
        tenantId: tenant().tenantId
      }
    ]
    tenantId: tenant().tenantId 
  }
}
