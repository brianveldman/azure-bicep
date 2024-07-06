param __location__ string
param _tags_ object
param _aiComputerVisionName_  string
param _aiComputerVisionSku_ string

resource aiCognitiveService 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: _aiComputerVisionName_ 
  location: __location__
  tags: _tags_
  sku: {
    name: _aiComputerVisionSku_
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
