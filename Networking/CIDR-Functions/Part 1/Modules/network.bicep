param location string
param aztags object
param azvnetname string
param azvnetaddresspace string
param azvnetsubnets int

// var SubnetCalculation = [for i in range (0, azvnetsubnets): cidrSubnet(azvnetaddresspace, 26, i)]

// resource AzVNet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
//   name: azvnetname
//   location: location
//   tags: aztags
//   properties: {
//     addressSpace: {
//       addressPrefixes: [azvnetaddresspace]
//     }
//     subnets: [ for (snet, i) in SubnetCalculation: {
//       name: i == 0 ? 'snet-workloads' : i == 1? 'snet-domain' : 'snet-${i}'
//       properties: {
//         addressPrefix: snet 
//       }
//     }
//     ]
//   }
// }


@description('Defining our network logic')
var SubnetCalculation = map(range(0, azvnetsubnets), i => { 
  name: i == 0 ? 'snet-workloads' : i == 1 ? 'snet-domain' : 'snet-${i}'
  properties: {
    addressPrefix: cidrSubnet(azvnetaddresspace, 26, i)
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
