metadata name = 'Azure Storage as code - Entra Only authentication'
metadata description = 'This Bicep code deploys Azure Storage as code with Entra Only authentication.'
metadata owner = 'Brian Veldman'
targetScope = 'subscription'

/* For loading Microsoft Graph Extension <3 */
extension 'br:mcr.microsoft.com/bicep/extensions/microsoftgraph/v1.0:1.0.0'

@allowed([
  'prod'
  'dev'
  'test'
])
@description('Defining our parameters')
param parEnvironment string = 'prod'
param parNumber string = '001'
param parLandingZone string = 'corp'
param parLocation string = 'westeurope'
param parShareName string = 'data'

@description('Defining our variables')
var varShortLocationName = substring(parLocation, 0, 6)
var stRgName = 'rg-${parLandingZone}-st-${parEnvironment}-${varShortLocationName}-${parNumber}'
@description('Deployment of Azure Resource Group for our Storage Account')
module rg 'br/public:avm/res/resources/resource-group:0.4.4' = {
  params: {
    name: stRgName
    location: parLocation
  }
}

@description('Deployment of Azure Storage Account for saving our data')
module st 'br/public:avm/res/storage/storage-account:0.27.1' = {
  name: 'mod-st-${deployment().name}'
  params: {
    name: 'st${parEnvironment}${parLandingZone}${varShortLocationName}${parNumber}'
    location: parLocation
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    roleAssignments: [
      {
        principalId: uami.outputs.principalId
        roleDefinitionIdOrName: '81a9662b-bebf-436f-a333-f67b29880f12'
      }
    ]
    fileServices: {
      shares: [
        {
          name: parShareName
          enabledProtocols: 'SMB'
          shareQuota: 10 //Explict set otherwise 5TB
        }
      ]
    }
    azureFilesIdentityBasedAuthentication: {
      directoryServiceOptions: 'AADKERB'
      defaultSharePermission: 'StorageFileDataSmbShareContributor'
    }
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
  scope: resourceGroup(stRgName)
  dependsOn: [
    rg
  ]
}

@description('Deployment of Microsoft Graph Writers Group for our Storage Account')
resource writersGroup 'Microsoft.Graph/groups@v1.0' = {
  displayName: 'writers-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
  mailEnabled: false
  mailNickname: 'writers-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
  securityEnabled: true
  uniqueName: 'writers-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
  dependsOn: [
    st
  ]
}

@description('Deployment of Microsoft Graph ReadersGroup for our Storage Account')
resource readersGroup 'Microsoft.Graph/groups@v1.0' = {
  displayName: 'readers-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
  mailEnabled: false
  mailNickname: 'readers-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
  securityEnabled: true
  uniqueName: 'readers-${parLandingZone}-${parEnvironment}-${varShortLocationName}-${parNumber}'
  dependsOn: [
    st
  ]
}
