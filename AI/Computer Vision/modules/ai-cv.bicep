param __location__ string
param _tags_ object
param _aiComputeVisionName_  string
param _aiComputeVisionSku_ string

resource aiCognitiveService 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: _aiComputeVisionName_ 
  location: __location__
  tags: _tags_
  sku: {
    name: _aiComputeVisionSku_
    tier: 'Free'
  }
  kind: 'ComputerVision'
  properties: {
  networkAcls: {
    defaultAction: 'Allow'
    ipRules: []
    virtualNetworkRules: []
  }   
  }
}
