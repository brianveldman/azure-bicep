param __location__ string
param _vnetHubName_ string
param _vnetHubAddrSpace_ string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: _vnetHubName_
  location: __location__
  properties: {
    addressSpace: {
      addressPrefixes: [
        _vnetHubAddrSpace_
      ]
    }
    subnets: [
      {
        name: 'snet-mps'
        properties: {
          addressPrefixes: [
            '10.10.10.0/24'
            '10.10.11.0/24'
          ]
        }
      }
    ]
  }
}
