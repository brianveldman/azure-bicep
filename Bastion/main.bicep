metadata name = 'Entra Bastion Lab Deployment'
metadata description = 'Deploys Entra Bastion lab'
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
var varShortEnvironmentMapping = {
  canadacentral: 'cnc'
  westus: 'wus'
  westus2: 'wus2'
  eastus: 'eus'
  eastus2: 'eus2'
  westeurope: 'weu'
}

var varShortEnvironment = varShortEnvironmentMapping[parLocation] ?? parLocation
var varResourceGroupName = 'rg-${parAlzName}-${parEnvironment}-${varShortEnvironment}-001'

@description('Resource Group Deployment')
resource entralabResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: varResourceGroupName
  location: parLocation
}

@description('Virtual Network Deployment')
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.7.1' = {
  params: {
    addressPrefixes: [
      '10.150.0.0/23'
    ]
    name: 'vnet-entra-lab-${varShortEnvironment}-001'
    location: parLocation
    subnets: [
      {
        name: 'snet-resources-${varShortEnvironment}'
        addressPrefix: '10.150.0.0/24'
      }
      {
        name: 'AzureBastionSubnet'
        addressPrefix: '10.150.1.0/26'
      }
    ]
  }
  scope: entralabResourceGroup
}

@description('Public IP Address Deployment')
module publicIpAddress 'br/public:avm/res/network/public-ip-address:0.10.0' = {
  params: {
    name: 'pip-bas-entra-lab-${varShortEnvironment}-001'
    location: parLocation
  }
  scope: entralabResourceGroup
}

@description('Bastion Host Deployment')
module bastionHost 'br/public:avm/res/network/bastion-host:0.8.2' = {
  params: {
    name: 'bas-entra-lab-${varShortEnvironment}-001'
    skuName: 'Standard'
    bastionSubnetPublicIpResourceId: publicIpAddress.outputs.resourceId
    virtualNetworkResourceId: virtualNetwork.outputs.resourceId
    location: parLocation
  }
  scope: entralabResourceGroup
}

@description('Virtual Machine Deployment')
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.21.0' = {
  params: {
    managedIdentities: {
      systemAssigned: true
    }
    availabilityZone: -1
    name: 'entralab${varShortEnvironment}001'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
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
    vmSize: 'Standard_B2s_v2'
    adminUsername: parAdminUsername
    adminPassword: parAdminPassword
    imageReference: {
      offer: 'windows-11'
      publisher: 'microsoftwindowsdesktop'
      sku: 'win11-25h2-pro'
      version: 'latest'
    }
    extensionAadJoinConfig: {
      enabled: true
      settings: {
        mdmId: '0000000a-0000-0000-c000-000000000000'
      }
    }
  }
  scope: entralabResourceGroup
}

@description('Role Assignment Deployment for Virtual Machine User Login - Needed for Entra ID')
module resourceRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'resourceRoleAssignmentDeployment'
  params: {
    principalId: deployer().objectId // Allow the deploying user to log in to the VM
    resourceId: virtualMachine.outputs.resourceId
    roleDefinitionId: 'fb879df8-f326-4884-b1cf-06f3ad86be52' // Virtual Machine User Login
  }
  scope: entralabResourceGroup
}
