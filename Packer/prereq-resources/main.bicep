metadata name = 'Azure - Packer Build Prerequisites'
metadata description = 'This Bicep code deploys Azure resources that are required for Packer builds'
metadata owner = 'Brian Veldman'
targetScope = 'subscription'
extension microsoftGraph 

@description('Parameters for new deployments')
param __location__ string = 'eastus'
param __env__ string = 'prod'
param __startDate__ string = utcNow('d-M-yyyy')
param __author__ string = 'Brian Veldman'
param __website__ string = 'CloudTips.nl'

@description('Tagging Variables')
var _tags_ = {
  createdBy: __author__
  website: __website__
  environment: __env__
  startDate: __startDate__
}

@description('Defining our vars')
var _packerResourceGroupName_ = 'rg-packer-dev'
var _imageResourceGroupName_ = 'rg-images-prod'

resource packerResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: _packerResourceGroupName_
  location: __location__
  tags: _tags_
}

resource imageResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: _imageResourceGroupName_
  location: __location__
  tags: _tags_
}

@description('Deployment MsGraph extension')
resource packerApp 'Microsoft.Graph/applications@v1.0' = {
  displayName: 'Packer Build Service Principal'
  uniqueName: 'Packer_Build_Service_Principal'
}

resource packerSp 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: packerApp.appId
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('Packer', 'roleAssignment')
  properties: {
    principalId: packerSp.id
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  }
}
