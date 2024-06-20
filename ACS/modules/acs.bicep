param _acsEmailServiceName_ string
param _acsServiceName_ string
param _acsDataLocation_ string

@description('Used to deploy the ECS')
resource acsEmailServices 'Microsoft.Communication/emailServices@2023-06-01-preview' = {
  name: _acsEmailServiceName_
  location: 'Global'
  properties: {
    dataLocation: _acsDataLocation_
  }
}

@description('Used to deploy Azure Managed Domain for demo')
resource acsAzManagedDomain 'Microsoft.Communication/emailServices/domains@2023-06-01-preview' = {
  parent: acsEmailServices
  name: 'AzureManagedDomain'
  location:  'Global'
  properties: {
    domainManagement: 'AzureManaged'
    userEngagementTracking: 'Disabled'
  }
}

@description('Used to deploy Azure Managed Test User for demo')
resource acsAzManagedDomainTestUser 'Microsoft.Communication/emailServices/domains/senderUsernames@2023-06-01-preview' = {
  parent: acsAzManagedDomain
  name: 'testct'
  properties: {
    username: 'testct'
    displayName: 'CloudTips Test'
  }
}

resource acsCommunicationService 'Microsoft.Communication/communicationServices@2023-06-01-preview' = {
  name: _acsServiceName_
  location: 'Global'
  properties: {
    dataLocation: _acsDataLocation_
    linkedDomains: [
      acsAzManagedDomain.id //Need to link Azure Managed Domain to CS
    ]
  } 
}
