param __location__ string
param _tags_ object
param _vnetHubName_ string
param _vnetHubAddrSpace_ string
param _vnetHubSubnetCount_ int
param _vnetSpokeName_ string 
param _vnetSpokeAddrSpace_ string
param _vnetSpokeSubnetCount_ int
param _routeTable_ string
param _vgwName_ string
param _vgwPipName_ string
param  __vgwEnabled__ bool

@description('Using CIDR function for calculations')
var _vnetHubSubnetCalculation_ = map(range(0,_vnetHubSubnetCount_), i =>{
  name: i == 0 ? 'AzureFirewallSubnet' : i == 1 ? 'AzureFirewallManagementSubnet' : 'GatewaySubnet'
  properties: {
    //Create subnets based on /26, because AzureFirewallSubnet is limited to /26
    //For beauty first subnet will be AzureFirewallSubnet, than AzureFirewallManagementSubnet and last GatewaySubnet
    //so x.x.x.0 for the first one and x.x.x.64 for the second one, and x.x.x.128 for the third <3
    addressPrefix: cidrSubnet(_vnetHubAddrSpace_, 26, i)

  }
})

var _afwIpv4_ = cidrHost(_vnetHubSubnetCalculation_[0].properties.addressPrefix, 4)
   //Collect IPv4 of the AFW, this picks the x.x.x.4, because thats the first IP

var _vnetSpokeCalculation_ = map(range(0, _vnetSpokeSubnetCount_), i =>{
  name: i == 0 ? 'snet-workloads-1' : i == 1 ? 'snet-workloads-2' : i == 2 ? 'snet-workloads-3' : 'snet-workloads-4'
  properties: {
    addressPrefix: cidrSubnet(_vnetSpokeAddrSpace_, 24, i)
    routeTable: {
      id: routeTable.id
    }
  }
})

resource routeTable 'Microsoft.Network/routeTables@2019-11-01' = {
  name: _routeTable_
  location: __location__
  properties: {
    routes: [ 
      {
        name: 'udr-route-all-through-afw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: _afwIpv4_
        }
      }
     ]
    disableBgpRoutePropagation: true
  }
}

resource vnetHub 'Microsoft.Network/virtualNetworks@2023-06-01' = {
  name: _vnetHubName_
  location: __location__
  tags: _tags_
  properties: {
    addressSpace: {
      addressPrefixes: [
       _vnetHubAddrSpace_
      ]
    }
    subnets: _vnetHubSubnetCalculation_
    
  }
}

resource vnetSpoke 'Microsoft.Network/virtualNetworks@2023-06-01' = {
  name: _vnetSpokeName_
  location: __location__
  properties: {
    addressSpace: {
      addressPrefixes: [
        _vnetSpokeAddrSpace_
      ]
    }
    subnets: _vnetSpokeCalculation_
  }
}

@description('Deploying Firewall PIP')
resource vgwPip 'Microsoft.Network/publicIPAddresses@2023-06-01' = {
  name: _vgwPipName_
  location: __location__
  tags: _tags_
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource vgw 'Microsoft.Network/virtualNetworkGateways@2023-06-01' = if (__vgwEnabled__) {
  name: _vgwName_
  location: __location__
  tags: _tags_
  properties: {
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vnetHub.properties.subnets[2].id
          }
          publicIPAddress: {
            id: vgwPip.id
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
  }
}

@description('VNet Peerings')
resource vnetHub2Spoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-06-01' = {
  name: '${_vnetHubName_}-to-${_vnetSpokeName_}'
  dependsOn: [
    vgw
  ]
  parent: vnetHub
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    //Hub must be able to forward traffic to spoke vnet
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetSpoke.id
    }
  }
}

resource vnetSpoke2Hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-06-01' = {
  name: '${_vnetSpokeName_}-to-${_vnetHubName_}'
  dependsOn: [
    vgw
  ]
  parent: vnetSpoke
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    //Spoke must use remote gateway to connect to S2S-resources such as on-premises VMs
    //You can only enable this feature if you deploy a VNet gateway which is not possible right now in West Europe
    //This is because the capacity issues in West Europe :/
    useRemoteGateways: __vgwEnabled__ ? true: false
    remoteVirtualNetwork: {
      id: vnetHub.id
    }
  }
}

@description('Outputting subnet ids for firewall')
output afwSubnet string = vnetHub.properties.subnets[0].id
output afwMgmtSubnet string = vnetHub.properties.subnets[1].id
