param __location__ string
param _maesterAutomationVariables_ array
param _appServiceName_ string
param _maesterResourceGroupName_ string
param _maesterAutomationAccountName_ string
param __maesterAutomationAccountModules__ array
param _maesterStorageAccountName_ string
param _maesterStorageBlobName_ string
param _maesterStorageBlobFileName_ string

@description('Automation Account Deployment')
resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' = {
  name: _maesterAutomationAccountName_
  location: __location__
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

@description('Create Automation Variables')
resource variables 'Microsoft.Automation/automationAccounts/variables@2023-11-01' = [for var in _maesterAutomationVariables_: {
  parent: automationAccount
  name: var.name
  properties: {
    value: var.value
    isEncrypted: var.isEncrypted
  }
}]

resource automationAccountRuntimeEnvironment 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  parent: automationAccount
  name: 'PowerShell-7.4'
  location: __location__
  properties: {
    runtime: {
      language: 'PowerShell'
      version: '7.4'
    }
  }
}

resource rtePackages 'Microsoft.Automation/automationAccounts/runtimeEnvironments/packages@2024-10-23' = [
  for m in __maesterAutomationAccountModules__: {
    name: m.name
    parent: automationAccountRuntimeEnvironment
    properties: {
      contentLink: {
        uri: m.uri
        version: m.version
      }
    }
  }
]
resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: _maesterStorageAccountName_
  location: __location__
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    networkAcls: {
      defaultAction: 'Allow'
    }
  }

}

@description('Create Blob Service')
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2025-01-01' = {
  parent: storageAccount
  name: 'default'
}

@description('Create Blob Container')
resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-01-01' = {
  parent: blobService
  name: _maesterStorageBlobName_
  properties: {
    publicAccess: 'Blob'
  }
}

@description('Upload .ps1 file to Blob Container using Deployment Script')
resource uploadScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'deployscript-upload-blob-maester'
  location: __location__
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.26.1'
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: storageAccount.name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: storageAccount.listKeys().keys[0].value
      }
      {
        name: 'CONTENT'
        value: loadTextContent('../pwsh/maester.ps1')
      }
    ]
    arguments: '-appName ${_appServiceName_} -rgName ${_maesterResourceGroupName_}'
    scriptContent: 'echo "$CONTENT" > ${_maesterStorageBlobFileName_} && az storage blob upload -f ${_maesterStorageBlobFileName_} -c ${_maesterStorageBlobName_} -n ${_maesterStorageBlobFileName_}'
  }
  dependsOn: [
    blobContainer
  ]
}

@description('Outputs')
output __ouMaesterAutomationMiId__ string = automationAccount.identity.principalId
output __ouMaesterScriptBlobUri__ string = 'https://${_maesterStorageAccountName_}.blob.${environment().suffixes.storage}/${_maesterStorageBlobName_}/maester.ps1'
