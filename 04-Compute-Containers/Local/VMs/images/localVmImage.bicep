targetScope = 'resourceGroup'

metadata name = 'Azure Local Image deployment'
metadata description = 'Template for deploying Arc Image for Azure Local VM'
metadata owner = 'Brian Veldman'
metadata versionnumber = '1.0.0'

@description('Name of the custom location')
param __customLocationName__ string = 'azlocal-038-location'

@description('Azure region where the resource will be deployed')
param __location__ string = 'West Europe'

param __imageName__ string = 'image-w25-smalldisk'
@allowed([ 'Windows' ])
param __osType__ string = 'Windows'
@allowed([ 
  'microsoftwindowsserver:windowsserver:2025-datacenter-azure-edition-smalldisk' ])
param __imageURN__ string
param __skuVersion__ string = '26100.2033.241205'
@allowed([ 'V2' ])
param __hyperVGeneration__ string = 'V2'

@description('Split the image URN into parts')
var _publisherId_ = split(__imageURN__, ':')[0]
var _offerId_ = split(__imageURN__, ':')[1]
var _planId_ = split(__imageURN__, ':')[2]

@description('Calculate the resource ID for custom location') 
var _customLocationId_ = resourceId('Microsoft.ExtendedLocation/customLocations', __customLocationName__)

resource _image_ 'Microsoft.AzureStackHCI/marketplaceGalleryImages@2023-09-01-preview' = {
  name: __imageName__
  location: __location__
  extendedLocation: {
    name: _customLocationId_
    type: 'CustomLocation'
  }
  properties: {
    osType: __osType__
    hyperVGeneration: __hyperVGeneration__
    identifier: {
      publisher: _publisherId_
      offer: _offerId_
      sku: _planId_
    }
    version: {
      name: __skuVersion__
    }
  }
  tags: {}
}
