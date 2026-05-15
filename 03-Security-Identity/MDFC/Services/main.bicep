metadata name = 'Deploy Defender for Cloud Services'
metadata description = 'This Bicep code deploys Microsoft Defender for Cloud services with a specified pricing tier.'
metadata owner = 'Brian Veldman'
targetScope = 'subscription'

@description('Main Parameters')
param parTier string
param parSolutions array

@description('Deployment Microsoft Defender For Cloud Services') 
resource mdfcServices 'Microsoft.Security/pricings@2024-01-01' = [for solution in parSolutions: {
  name: solution
  properties: {
    pricingTier: parTier
    subPlan: solution == 'Api' ? 'P1' : null
  }
}]
