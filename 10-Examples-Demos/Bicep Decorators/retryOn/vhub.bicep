@retryOn(['ResourceNotFound'], 10)
@batchSize(2)
resource vHub 'Microsoft.Network/virtualHubs@2024-07-01' = [for i in range(0, 8): {
  name: 'vhub-${parRegionNamePrefix}-${i}'
  location: parLocation
  properties: {
    addressPrefix: parVwanHubCIDR
  }
}]
