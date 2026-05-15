param __location__ string
param __galleryName__ string
param __galleryDefinition__ string

resource gal 'Microsoft.Compute/galleries@2024-03-03' = {
  name: __galleryName__
  location: __location__
}

resource gallDefinition 'Microsoft.Compute/galleries/images@2024-03-03' = {
  parent: gal
  name: __galleryDefinition__
  location: __location__
  properties: {
    hyperVGeneration: 'V2'
    architecture: 'x64'
    features: [
      {
        name: 'SecurityType'
        value: 'TrustedLaunchSupported'
      }
    ]
    osType: 'Windows'
    osState: 'Generalized'
    identifier: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-azure-edition'
    }
  }
}
