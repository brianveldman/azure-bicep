param __location__ string
param _tags_ object
param _oaiResourceName_ string
param _oaiKind_ string
param _oaiApiVersion_ string
param _oaiSku_ string
param _oaiModelName_ string
param _oaiDeploymentModelName_ string

resource openAi 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: _oaiResourceName_
  location: __location__
  tags: _tags_
  kind: _oaiKind_
  sku: {
    name: _oaiSku_
  }
  properties: {
    customSubDomainName: toLower(_oaiResourceName_)
  }
}

resource openAiModelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  name: _oaiDeploymentModelName_
  parent: openAi
  sku: {
    capacity: 1
    name: 'Standard'
  }
  properties: {
    model: {
      name: _oaiModelName_
      format: _oaiKind_
      version: _oaiApiVersion_
    }
    raiPolicyName: 'Microsoft.DefaultV2'
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
  }
}
