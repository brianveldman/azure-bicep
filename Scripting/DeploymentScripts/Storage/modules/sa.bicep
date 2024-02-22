param __location__ string
param __cust__ string
param _tags_ object
param _saName_ string
param _saContainerName_ string
param _miName_ string
param _deploymentScriptName_ string

@description('Deployment of Storage Account')
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: _saName_
  location: __location__
  tags: _tags_
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    minimumTlsVersion: 'TLS1_2'
  }
}

@description('Deployment of User Assigned MI')
resource userManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: _miName_
  location: __location__ 
}

//Fetching SA role
param __saContributor__ string = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/17d1049b-9a84-46fb-8f53-869881c3d3ab'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userManagedIdentity.id, '${__cust__}')
  properties: {
    principalId: userManagedIdentity.properties.principalId
    roleDefinitionId: __saContributor__
    principalType: 'ServicePrincipal'
  }
}

@description('Deployment of DeploymentScript =)')
resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  dependsOn: [
    storageaccount
  ]
  name: _deploymentScriptName_
  location: __location__
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userManagedIdentity.id}' : {}
    }
  }
  properties: {
    //Define azPwshVersion
    azPowerShellVersion: '11.0'
    //Define how long to store results
    retentionInterval: 'P1D'
    arguments: '-saName ${_saName_} -rgName ${resourceGroup().name} -saContainerName ${_saContainerName_}'
    scriptContent: loadTextContent('./pwsh/sa.ps1')
  }
}
