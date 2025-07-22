param __ciamLocation__ string
param __ciamName__ string
param __ciamSkuName__ string
param __ciamSkuTier__ string
param __ciamCountryCode__ string

resource ciamDirectory 'Microsoft.AzureActiveDirectory/ciamDirectories@2023-05-17-preview' = {
  name: '${__ciamName__}.onmicrosoft.com'
  location: __ciamLocation__
  sku: {
    name: __ciamSkuName__
    tier: __ciamSkuTier__
  }
  properties: {
    createTenantProperties: {
      countryCode: __ciamCountryCode__
      displayName: __ciamName__
    }
  }
}
