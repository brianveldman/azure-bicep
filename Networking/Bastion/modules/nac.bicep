param __location__ string
param _tags_ object
param _vnetSpokeName_ string 
param _vnetSpokeAddrSpace_ string
param _publicIpAddressName_ string
param _bastionHostName_ string
param _storageAccountName_ string
param _blobContainerName_ string
param _keyVaultName_ string


@description('Deploying VNet to host our workloads')
resource vnetSpoke 'Microsoft.Network/virtualNetworks@2023-06-01' = {
  name: _vnetSpokeName_
  location: __location__
  tags: _tags_
  properties: {
    addressSpace: {
      addressPrefixes: [
        _vnetSpokeAddrSpace_
      ]
    }
    subnets: [
      {
        name: 'snet-workloads-prod'
        properties: {
          addressPrefix: '10.151.0.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.151.1.0/26'
        }
      }
    ]
  }
}

@description('Deploying Public IP for Bastion Host')
resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: _publicIpAddressName_
  location: __location__
  tags: _tags_
  sku: {
    name: 'Standard'
   }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

@description('Deploying Bastion Host')
resource bastion 'Microsoft.Network/bastionHosts@2023-11-01' = {
  name: _bastionHostName_
  location: __location__
  tags: _tags_
  sku: {
    name: 'Premium'
  }
  properties: {
    ipConfigurations: [
      { 
        name: 'IpConf'
        properties: {
          publicIPAddress: {
            id: publicIPAddress.id
          }
          subnet: {
            id: vnetSpoke.properties.subnets[1].id
          }
        }
      }
    ]
    enableSessionRecording: true //Ignore the yellow mark since we know better =D
  }
}

@description('Deploying our Storage Account')
resource basSrStorageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: _storageAccountName_
  location: __location__
  tags: union(_tags_,{
    'hidden-title' : 'sa-bas-recordings-prod - Used for saving Bastion Session Recordings'
  })
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

@description('Activating our Blob service with CORS')
resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  name: 'default'
  parent:  basSrStorageAccount
  properties: {
    cors: {
      corsRules: [
        {
          allowedHeaders: ['*']
          allowedMethods: ['GET']
          allowedOrigins: ['HTTPS://${bastion.properties.dnsName}']
          exposedHeaders: ['*']
          maxAgeInSeconds: 86400
        }
      ]
    }
  }
}

@description('Deploying the blob container')
resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: _blobContainerName_
  parent: blobServices
  properties: {
  }
}

@description('Deploying key vault for safing secrets')
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: _keyVaultName_
  location: __location__
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        objectId: 'e06ee165-378b-488c-8366-87b3fb3b9888' // My own objectID in EntraID
        permissions: {
          secrets: [
            'get'
            'list'
            'set'
          ]
        }
        tenantId: subscription().tenantId
      }
    ]
  }
}

@description('Defining expiration for the SAS')
param __currentTime__ string = utcNow()
var _startTime_ = dateTimeAdd(__currentTime__, '-PT15M') 
var _expiryTime_ = dateTimeAdd(_startTime_, 'P1Y') 

var _sasConfig_ = {
  canonicalizedResource: '/blob/${basSrStorageAccount.name}/${blobContainer.name}'
  signedResourceTypes: 'sco'
  signedPermission: 'rcwl'
  signedServices: 'b'
  signedResource: 'c'
  signedStart: _startTime_
  signedExpiry: _expiryTime_
  signedProtocol: 'https'
  keyToSign: 'key1'
}

@description('Generating the SAS')
var _sasToken_ = listAccountSas(basSrStorageAccount.id,'2021-04-01', _sasConfig_).accountSasToken

@description('Building our sasTokenURL for correct input to Bastion')
var sasTokenUrl = 'https://${basSrStorageAccount.name}.blob.${environment().suffixes.storage}/${blobContainer.name}?sp=rcwl&st=${_startTime_}&se=${_expiryTime_}&spr=https&sv=2022-09-01&sr=c&sig=${_sasToken_}'

@description('Store our secret towards Azure Key Vault')
resource secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: keyVault
  name: 'ct-sasToken'
  properties: {
    value: sasTokenUrl
  }
}

