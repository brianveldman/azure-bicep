targetScope = 'subscription'

param parLocation string = 'westeurope'

resource rg 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: 'rg-finops-hub'
  location: parLocation
}

module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:0.1.1' = {
  name: 'finopsHubDeployment'
  params: {
    // Required parameters
    hubName: 'ct-finops-hub-finmin'
    // Non-required parameters
    location: parLocation
  }
  scope: rg
}
