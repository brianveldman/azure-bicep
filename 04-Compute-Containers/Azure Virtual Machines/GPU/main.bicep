metadata name = 'GPU VM Lab Deployment'
metadata description = 'Deploys GPU VM Lab'
metadata owner = 'Brian Veldman'
metadata version = '1.0.0'
targetScope = 'subscription'

@description('Defing our input parameters')
param parEnvironment string
param parAlzName string
@allowed([
  'canadacentral'
  'westus'
  'westus2'
  'eastus'
  'eastus2'
  'westeurope'
])
param parLocation string
param parAdminUsername string
@secure()
param parAdminPassword string

@description('Defining our variables')
var solutionName = 'gpu'
var shortEnvironmentMapping = {
  canadacentral: 'cnc'
  westus: 'wus'
  westus2: 'wus2'
  eastus: 'eus'
  eastus2: 'eus2'
  westeurope: 'weu'
}

var shortEnvironment = shortEnvironmentMapping[parLocation] ?? parLocation
var resourceGroupName = 'rg-${solutionName}-${parAlzName}-${parEnvironment}-${shortEnvironment}-001'

@description('Resource Group Deployment')
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: parLocation
}

@description('Virtual Network Deployment')
module vn 'br/public:avm/res/network/virtual-network:0.7.1' = {
  params: {
    addressPrefixes: [
      '10.170.0.0/23'
    ]
    name: 'vnet-gpu-lab-${shortEnvironment}-001'
    location: parLocation
    subnets: [
      {
        name: 'snet-resources-${shortEnvironment}'
        addressPrefix: '10.170.0.0/24'
      }
    ]
  }
  scope: rg
}

@description('Public IP Address Deployment')
module pip 'br/public:avm/res/network/public-ip-address:0.10.0' = {
  params: {
    name: 'pip-vm-${solutionName}-lab-${shortEnvironment}-001'
    location: parLocation
  }
  scope: rg
}

@description('Defining our GPU VM')
module vm 'br/public:avm/res/compute/virtual-machine:0.22.1' = {
  params: {
    availabilityZone: -1
    name: 'vm-${solutionName}-001'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: vn.outputs.subnetResourceIds[0]
            pipConfiguration: {
              publicIPAddressResourceId: pip.outputs.resourceId
            }
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_NV6ads_A10_v5'
    adminPassword: parAdminPassword
    adminUsername: parAdminUsername
    extensionNvidiaGpuDriverWindows: {
      enabled: true
    }
    hibernationEnabled: true
    imageReference: {
      offer: 'windows-11'
      publisher: 'microsoftwindowsdesktop'
      sku: 'win11-25h2-ent'
      version: 'latest'
    }
    location: parLocation
  }
  scope: resourceGroup(resourceGroupName)
}
