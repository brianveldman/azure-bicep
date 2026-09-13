metadata name = 'Azure Firewall Explicit Proxy Lab Deployment'
metadata description = 'Deploys Azure Firewall Explicit Proxy resources for lab'
metadata owner = 'Brian Veldman'
metadata version = '1.0.0'

targetScope = 'resourceGroup'

@description('Defining our input parameters')
@allowed([
  'westeurope'
  'northeurope'
  'germanywestcentral'
  'canadacentral'
  'australiaeast'
])
param parLocation string = 'canadacentral'
param parEnvironment string = 'prod'
param parLandingZone string = 'con'
param parNumber string = '001'
param parStartDate string = utcNow('yyyy-MM-dd')
param parTags object = {
  environment: parEnvironment
  location: parLocation
  deploymentNumber: parNumber
  startDate: parStartDate
  landingZone: parLandingZone
}

@description('Defining our Variables')
var varShortEnvironmentMapping = {
  westeurope: 'weu'
  northeurope: 'neu'
  germanywestcentral: 'dewc'
  canadacentral: 'cac'
  australiaeast: 'eau'
}

var varShortEnvironment = varShortEnvironmentMapping[parLocation] ?? parLocation
var virtualNetworkName = 'vnet-${varShortEnvironment}-${parLandingZone}-${parEnvironment}-${parNumber}'
var firewallPublicIPName = 'pip-afw-${varShortEnvironment}-${parLandingZone}-${parEnvironment}-${parNumber}'
var firewallPolicyName = 'afwp-${varShortEnvironment}-${parLandingZone}-${parEnvironment}-${parNumber}'
var firewallName = 'afw-${varShortEnvironment}-${parLandingZone}-${parEnvironment}-${parNumber}'

@description('Defining the virtual network')
resource vn 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworkName
  location: parLocation
  tags: parTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.200.10.0/23'
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.200.10.0/26'
        }
      }
      {
        name: 'snet-workloads-${parEnvironment}'
        properties: {
          addressPrefix: '10.200.11.0/24'
        }
      }
    ]
  }
}

@description('Defining the Azure Firewall Policy')
resource fwPol 'Microsoft.Network/firewallPolicies@2024-07-01' = {
  name: firewallPolicyName
  location: parLocation
  tags: parTags
  properties: {
    sku: {
      tier: 'Premium'
    }
    explicitProxy: {
      enableExplicitProxy: true
      enablePacFile: false
      httpsPort: 9001 // You can use a single port HTTP Port for both HTTP and HTTPS traffic.
    }
  }
}

@description('Deploying Firewall PIP')
resource pip 'Microsoft.Network/publicIPAddresses@2023-06-01' = {
  name: firewallPublicIPName
  location: parLocation
  tags: parTags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

@description('Defining the Azure Firewall')
resource fw 'Microsoft.Network/azureFirewalls@2024-07-01' = {
  name: firewallName
  location: parLocation
  tags: parTags
  properties: {
    sku: {
      tier: 'Premium'
      name: 'AZFW_VNet'
    }
    ipConfigurations: [
      {
        name: 'afwIpConfig'
        properties: {
          publicIPAddress: {
            id: pip.id
          }
          subnet: {
            id: vn.properties.subnets[0].id
          }
        }
      }
    ]
    firewallPolicy: {
      id: fwPol.id
    }
  }
}
