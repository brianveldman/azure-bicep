param parLocation string
param parEnvironment string
param parLandingZone string
param parNumber string

var varShortLocationName = substring(parLocation, 0, 6)
var varStName = 'st${parEnvironment}${parLandingZone}${varShortLocationName}${parNumber}'
var varShareName = 'data'

@description('Deployment of Azure Storage Account for saving our data')
module st 'br/public:avm/res/storage/storage-account:0.27.1' = {
  name: 'mod-st-${deployment().name}'
  params: {
    name: varStName
    location: parLocation
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    fileServices: {
      shares: [
        {
          name: varShareName
          enabledProtocols: 'SMB'
          shareQuota: 10 //Explict set otherwise 5TB
        }
      ]
    }
    azureFilesIdentityBasedAuthentication: {
      directoryServiceOptions: 'AADKERB'
      defaultSharePermission: 'StorageFileDataSmbShareElevatedContributor'
    }
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
}
