targetScope = 'subscription'

metadata name = 'Azure Local AKS deployment'
metadata description = 'Template for deploying Arc AKS on Azure Local'
metadata owner = 'Brian Veldman'
metadata versionnumber = '1.0.0'

@description('Deployment location')
param __location__ string = 'westeurope'

@description('Environment')
param __env__ string = 'prod'

@description('Solution name')
param __sln__ string = 'ct'

@description('Start date')
param __startDate__ string = utcNow('d-M-yyyy')

@description('Author')
param __author__ string = 'Brian Veldman'

@description('Website')
param __website__ string = 'CloudTips.nl'

@description('Custom location name')
param __customLocationName__ string = 'azlocal-038-location'

@description('Resource Group name where cluster lives')
param __localClResourceGroup__ string = 'rg-local-prod'

@description('Logical network name')
param __logicalNetworkName__ string = 'local-logical-network-prod'

@description('AKS Cluster Name')
param __aksClusterName__ string = 'aks-${__sln__}01-${__env__}'

@description('AKS Admin Group Object ID')
param __aksAdminGroupObjectId__ string = '382b4253-92e7-4084-9964-32f71f248640'

@description('AKS Control Plane IP')
param __aksControlPlaneIP__ string = '192.168.0.160'

@description('AKS Control Plane Node Count')
@maxValue(5)
param __aksControlPlaneNodeCount__ int = 1

@description('AKS Control Plane Node Size')
param __aksControlPlaneNodeSize__ string = 'Standard_A4_v2'

@description('AKS Pod CIDR')
param __aksPodCidr__ string = '10.244.0.0/16'

@description('AKS Kubernetes Version')
param __aksKubernetesVersion__ string = 'v1.26.6'

@description('AKS Node Pool Name')
param __aksNodePoolName__ string

@description('AKS Node Pool Node Count')
param __aksNodePoolNodeCount__ int = 1

@description('AKS Node Pool Node Size')
param __aksNodePoolNodeSize__ string = 'Standard_A4_v2'

@description('AKS Node Pool OS Type')
@allowed(['Linux', 'Windows'])
param __aksNodePoolOSType__ string = 'Linux'

@description('SSH Public Key')
param __sshPublicKey__ string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDjQuEKhiBFACQFOqn3J3+Kj8c15rA6qQgKQ0Ar6QtByeyj01J2Xiy4qWAdF7AxkG2wAB/JS59yrFR2sFRS8CTax4ayIBGHeUgKCbfM162OZqYOqFrVSWAq6hxONB/tCWx5mrVgBVJcWS5onqVuJox8aBcOlUQcL/izTinh99AmCIfnQ/Djdl6lC0XRILc0tzj6Yth4ZDYFpYT1k/YVWYv6a+WmNtA6bPFUn7adtNhd0hiFR4XZCnvEzLSigT19FGSDVT6I2r4OAz06vyRJ7f/khox7VsnZuXODfT7GDc818CF1xwuPZkJGPZumVZ9KBF+uBoETq+6p4Mfdijz0w2XaJfX+ufZa25nVohI5ALqbOk5Wb88x3cusC8jeqluf5lbb7+oQEu1NuQVTIkFEYv3w2db8PIGa2KCVT5NxFIqqjXiK1H9BfolnE5WTE+WAwpiYha/upbORD+QB/mfZaebQJRiVL70bSzepwmZSwLIEpfaDjHldgHFVnR2prRhLXLU= generated-by-azure'

var _tags_ = {
  createdBy: __author__
  website: __website__
  environment: __env__
  startDate: __startDate__
}
var _aksResourceGroupName_ = 'rg-local-aks-${__env__}'

resource aksResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: _aksResourceGroupName_
  location: __location__
  tags: _tags_
}
module modLocalAKS './modules/aks.bicep' = {
  name: 'deployment-local-aks-module-${__env__}'
  scope: aksResourceGroup
  params: {
    __location__: __location__
    _tags_: _tags_
    __customLocationName__: __customLocationName__
    __localClResourceGroup__: __localClResourceGroup__
    __logicalNetworkName__: __logicalNetworkName__
    __aksClusterName__: __aksClusterName__
    __aksAdminGroupObjectId__: __aksAdminGroupObjectId__
    __aksControlPlaneIP__: __aksControlPlaneIP__
    __aksControlPlaneNodeCount__: __aksControlPlaneNodeCount__
    __aksControlPlaneNodeSize__: __aksControlPlaneNodeSize__
    __aksPodCidr__: __aksPodCidr__
    __aksKubernetesVersion__: __aksKubernetesVersion__
    __aksNodePoolName__: __aksNodePoolName__
    __aksNodePoolNodeCount__: __aksNodePoolNodeCount__
    __aksNodePoolNodeSize__: __aksNodePoolNodeSize__
    __aksNodePoolOSType__: __aksNodePoolOSType__
    __sshPublicKey__: __sshPublicKey__
  }
}
