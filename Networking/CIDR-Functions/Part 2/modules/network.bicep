param location string
param aztags object
param azvnetname string
param azvnetaddresspace string

@description('Defining our network logic')
var SubnetCalculation = map(range(0, 2), i => { 
  name: i ==0 ? 'snet-func-workloads' :  'snet-func-serverfarms' 
  properties: {
    addressPrefix: i ==0 ? cidrSubnet(azvnetaddresspace, 24, 0) : cidrSubnet(azvnetaddresspace, 27, 8) 
    delegations:  i == 1 ? [
      {
        name: 'Microsoft.Web/serverfarms'
        properties: {
          serviceName: 'Microsoft.Web/serverfarms'
        }
      }
    ] : []
  }
})

resource AzVNet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: azvnetname
  location: location
  tags: aztags
  properties: {
    addressSpace: {
      addressPrefixes: [azvnetaddresspace]
    }
    subnets: SubnetCalculation
  }
}

// This will create two subnets:
// snet-func-workloads: 10.150.0/24
// snet-func-serverfarms: 10.150.1.0/27 with delegation for server farms 
