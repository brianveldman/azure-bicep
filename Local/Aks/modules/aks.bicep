param __location__ string
param _tags_ object
param __customLocationName__ string
param __localClResourceGroup__ string
param __logicalNetworkName__ string
param __aksClusterName__ string
param __aksAdminGroupObjectId__ string
param __aksControlPlaneIP__ string
param __aksControlPlaneNodeCount__ int
param __aksControlPlaneNodeSize__ string
param __aksPodCidr__ string
param __aksKubernetesVersion__ string
param __aksNodePoolName__ string
param __aksNodePoolNodeCount__ int
param __aksNodePoolNodeSize__ string
param __aksNodePoolOSType__ string
param __sshPublicKey__ string

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
resource cc 'Microsoft.Kubernetes/ConnectedClusters@2024-01-01' = {
  name: __aksClusterName__
  location: __location__
  tags: _tags_
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'ProvisionedCluster'
  properties: {
    agentPublicKeyCertificate: ''
    aadProfile: {
      enableAzureRBAC: false
      adminGroupObjectIDs: [__aksAdminGroupObjectId__]
    }
  }
}

@description('create the provisioned cluster instance - this is the actual AKS cluster and provisioned on your HCI cluster via the Arc Resource Bridge')
resource pci 'Microsoft.HybridContainerService/provisionedClusterInstances@2024-01-01' = {
  name: 'default'
  scope: cc
  extendedLocation: {
    type: 'CustomLocation'
    name: customLocation.id
  }
  properties: {
    linuxProfile: {
      ssh: {
        publicKeys: [
          {
            keyData: __sshPublicKey__
          }
        ]
      }
    }
    controlPlane: {
      count: __aksControlPlaneNodeCount__
      controlPlaneEndpoint: {
        hostIP: __aksControlPlaneIP__
      }
      vmSize: __aksControlPlaneNodeSize__
    }
    kubernetesVersion: __aksKubernetesVersion__
    networkProfile: {
      loadBalancerProfile: {
        count: 0 // use MetalLB
      }
      networkPolicy: 'calico'
      podCidr: __aksPodCidr__
    }
    agentPoolProfiles: [
      {
        name: __aksNodePoolName__
        count: __aksNodePoolNodeCount__
        vmSize: __aksNodePoolNodeSize__
        osType: __aksNodePoolOSType__
      }
    ]
    cloudProviderProfile: {
      infraNetworkProfile: {
        vnetSubnetIds: [
          logicalNetwork.id
        ]
      }
    }
    storageProfile: {
      nfsCsiDriver: {
        enabled: false
      }
      smbCsiDriver: {
        enabled: false
      }
    }
  }
}
