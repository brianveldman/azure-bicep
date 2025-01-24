targetScope = 'subscription'

metadata name = 'Azure Local VM deployment'
metadata description = 'Template for deploying Arc VM on Azure Local'
metadata owner = 'Brian Veldman'
metadata versionnumber = '1.0.0'

@description('Deployment location')
param __location__ string = 'westeurope'

@description('Environment')
param __env__ string = 'prod'

@description('Solution name')
param __sln__ string = 'a'

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
param __logicalNetworkName__ string = 'local-logical-network'

@description('VM name')
param __vmName__ string = 'vm-${__sln__}-l-t-001'

@description('Image name')
param __imageName__ string = 'image-w25-smalldisk'

@description('VM local admin user')
param __vmLocalAdminUser__ string = 'ctadmin'

@minLength(12)
@secure()
param __vmLocalAdminPassword__ string

var _tags_ = {
  createdBy: __author__
  website: __website__
  environment: __env__
  startDate: __startDate__
}
var _vmResourceGroupName_ = 'rg-local-vms-${__env__}'

resource vmResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: _vmResourceGroupName_
  location: __location__
  tags: _tags_
}

resource existingImage 'Microsoft.AzureStackHCI/marketplaceGalleryImages@2024-08-01-preview' existing = {
  name: __imageName__
scope: resourceGroup(__localClResourceGroup__)
}

module modLocalVM './modules/vm.bicep' = {
  name: 'deployment-local-vm-module-${__env__}'
  scope: vmResourceGroup
  params: {
    __location__: __location__
    _tags_: _tags_
    __customLocationName__: __customLocationName__
    __localClResourceGroup__: __localClResourceGroup__
    __logicalNetworkName__: __logicalNetworkName__
    __vmName__:__vmName__
    __existingImageName__: existingImage.id
    __vmLocalAdminUser__: __vmLocalAdminUser__
    __vmLocalAdminPassword__: __vmLocalAdminPassword__
  }
}
