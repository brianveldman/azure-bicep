param __location__ string
param _tags_ object
param _afwName_ string
param _afwPipName_ string
param _afwMgmtPipName_ string
param _afwpName_ string
param __loggingEnabled__ bool
param _lawName_ string

@description('Outputs from other modules')
param afwSubnet string
param afwMgmtSubnet string

@description('Deploying Firewall PIP')
resource afwPip 'Microsoft.Network/publicIPAddresses@2023-06-01' = {
  name: _afwPipName_
  location: __location__
  tags: _tags_
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

@description('Deploying Firewall Management PIP')
resource afwMgmtPip 'Microsoft.Network/publicIPAddresses@2023-06-01' = {
  name: _afwMgmtPipName_
  location: __location__
  tags: _tags_
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

@description('Deploying Firewall Basic Policy')
resource afwp 'Microsoft.Network/firewallPolicies@2023-06-01' = {
  name: _afwpName_
  location: __location__
  tags: _tags_
  properties: {
    sku: {
      tier: 'Basic'
    }
  }
}

@description('Deploying Firewall Basic')
resource afw 'Microsoft.Network/azureFirewalls@2023-06-01' = {
  name: _afwName_
  location: __location__
  tags: _tags_
  properties: {
    sku: {
      //AZFW_HUB for vWAN Hub otherwise AZFW_VNET
      name: 'AZFW_VNet'
      tier: 'Basic'
    }
    ipConfigurations: [
      {
       name: 'afwIpConfig'
       properties: {
        publicIPAddress: {
          id: afwPip.id

        }
        subnet: {
          id: afwSubnet
        }
       } 
      }
    ]
    managementIpConfiguration: {
      name: 'afwMgmtPipConfig' 
      properties: {
        publicIPAddress: {
          id: afwMgmtPip.id
        }
        subnet: {
          id: afwMgmtSubnet
        }
      }
    }
    firewallPolicy: {
      id: afwp.id
    }
  }
}

resource networkingLogAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = if (__loggingEnabled__) {
  name: _lawName_
  location: __location__
  tags: _tags_
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource afwLogging 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (__loggingEnabled__) {
  name: 'afwlogging'
  scope: afw
  properties: {
    workspaceId: networkingLogAnalytics.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
}
