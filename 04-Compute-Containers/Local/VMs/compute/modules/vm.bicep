param __location__ string
param _tags_ object
param __customLocationName__ string
param __localClResourceGroup__ string
param __logicalNetworkName__ string
param __vmName__ string
param __existingImageName__ string
param __vmLocalAdminUser__ string

@secure()
param __vmLocalAdminPassword__ string

@description('Retrievement existing custom location and logical network') 
resource customLocation 'Microsoft.ExtendedLocation/customLocations@2021-08-31-preview'  existing = {
  name: __customLocationName__
  scope: resourceGroup(__localClResourceGroup__)
}

resource logicalNetwork 'Microsoft.AzureStackHCI/logicalNetworks@2024-08-01-preview' existing = {
  name: __logicalNetworkName__
  scope: resourceGroup(__localClResourceGroup__)
}

@description('Pre-create an Arc Connected Machine with an identity--used for zero-touch onboarding')
resource hcm 'Microsoft.HybridCompute/machines@2024-07-10' = {
  name: __vmName__
  location: __location__
  kind: 'HCI'
  identity: {
    type: 'SystemAssigned'
  } 
}

@description('Network interface deployment with dynamically allocated IP')
resource nic 'Microsoft.AzureStackHCI/networkInterfaces@2024-08-01-preview' = {
  name: 'nic-${__vmName__}'
  location: __location__
  tags: _tags_
  extendedLocation: {
    name: customLocation.id
    type: 'CustomLocation'
  }
  properties: {
    dnsSettings: {}
    ipConfigurations: [
      {
        name: __vmName__
        properties: {
          privateIPAddress: '192.168.0.85'
          subnet: {
            id: logicalNetwork.id
          }
        }
      }
    ]
  }
}

@description('VM deployment with TPM and Secure Boot enabled')
resource vm 'Microsoft.AzureStackHCI/VirtualMachineInstances@2023-09-01-preview' = {
  scope: hcm
  name: 'default'
  extendedLocation: {
    name: customLocation.id
    type: 'CustomLocation'
  }
  properties: {
    hardwareProfile: {
      memoryMB: 4096
      processors: 4
      vmSize: 'Custom'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    osProfile: {
      adminUsername: __vmLocalAdminUser__
      adminPassword: __vmLocalAdminPassword__
      computerName: __vmName__
      windowsConfiguration: {
        provisionVMAgent: true
      }
    }
    securityProfile: {
      enableTPM: true
      uefiSettings: {
        secureBootEnabled: true
      }
    }
    storageProfile: {
      imageReference: {
        id: __existingImageName__
      }
    }
  }
}
