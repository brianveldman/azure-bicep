param __location__ string
param __scUnits__ int
param __scCrossGeoCompute__ bool
param __scGeo__ string
param _scCapacityName_ string

resource securityCopilot 'Microsoft.SecurityCopilot/capacities@2023-12-01-preview' = {
  name: _scCapacityName_
  location: __location__
  properties: {
      numberOfUnits: __scUnits__
      crossGeoCompute: __scCrossGeoCompute__
      geo: __scGeo__
  }
}
