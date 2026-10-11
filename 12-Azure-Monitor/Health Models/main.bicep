@description('Azure region for the health model and supporting resources.')
param location string = resourceGroup().location

@description('Name of the health model to create.')
param healthModelName string = 'health-model-${uniqueString(resourceGroup().id)}'

var suffix = uniqueString(subscription().id, resourceGroup().id)
var readerRoleDefinitionId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'acdd72a7-3385-48ef-bd42-f606fba81ae7'
)

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'st${suffix}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-${suffix}'
  location: location
  properties: {
    accessPolicies: []
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2026-01-01' = {
  name: 'pip-${suffix}'
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
  sku: {
    name: 'StandardV2'
    tier: 'Regional'
  }
}

resource natGateway 'Microsoft.Network/natGateways@2026-01-01' = {
  name: 'ng-${suffix}-01'
  location: location
  sku: {
    name: 'StandardV2'
  }
  properties: {
    publicIpAddresses: [
      {
        id: publicIp.id
      }
    ]
  }
}

resource healthModel 'Microsoft.CloudHealth/healthmodels@2026-05-01-preview' = {
  name: healthModelName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

resource readerRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, healthModel.id, readerRoleDefinitionId)
  properties: {
    principalId: healthModel.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: readerRoleDefinitionId
  }
}

resource authenticationSetting 'Microsoft.CloudHealth/healthmodels/authenticationsettings@2026-05-01-preview' = {
  parent: healthModel
  name: 'monitoring-identity'
  dependsOn: [
    readerRoleAssignment
  ]
  properties: {
    authenticationKind: 'ManagedIdentity'
    displayName: 'Monitoring identity'
    managedIdentityName: 'SystemAssigned'
  }
}

resource applicationEntity 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'application'
  properties: {
    canvasPosition: {
      x: 290
      y: 169
    }
    displayName: 'Application'
  }
}

resource storageEntity 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'storage'
  properties: {
    canvasPosition: {
      x: 0
      y: 400
    }
    displayName: 'Storage account'
    signalGroups: {
      azureResource: {
        authenticationSetting: authenticationSetting.name
        azureResourceId: storageAccount.id
        azureResourceKind: 'StorageV2'
        signals: [
          {
            aggregationType: 'Average'
            dataUnit: 'Percent'
            displayName: 'Storage availability (%)'
            evaluationRules: {
              degradedRule: {
                operator: 'LessThan'
                threshold: 100
              }
              unhealthyRule: {
                operator: 'LessThan'
                threshold: 99
              }
            }
            metricName: 'Availability'
            metricNamespace: 'Microsoft.Storage/storageAccounts'
            name: 'availability'
            refreshInterval: 'PT5M'
            signalKind: 'AzureResourceMetric'
            timeGrain: 'PT5M'
          }
        ]
      }
    }
  }
}

resource keyVaultEntity 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'key-vault'
  properties: {
    canvasPosition: {
      x: 290
      y: 400
    }
    displayName: 'Key Vault'
    impact: 'Limited'
    signalGroups: {
      azureResource: {
        authenticationSetting: authenticationSetting.name
        azureResourceId: keyVault.id
        azureResourceKind: ''
        signals: [
          {
            aggregationType: 'Average'
            dataUnit: 'Percent'
            displayName: 'Key Vault availability (%)'
            evaluationRules: {
              degradedRule: {
                operator: 'LessThan'
                threshold: 100
              }
              unhealthyRule: {
                operator: 'LessThan'
                threshold: 99
              }
            }
            metricName: 'Availability'
            metricNamespace: 'Microsoft.KeyVault/vaults'
            name: 'availability'
            refreshInterval: 'PT5M'
            signalKind: 'AzureResourceMetric'
            timeGrain: 'PT5M'
          }
        ]
      }
    }
  }
}

resource publicIpEntity 'microsoft.cloudhealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'public-ip'
  properties: {
    displayName: 'Public IP'
    canvasPosition: {
      x: 600
      y: 550
    }
    icon: {
      iconName: 'Resource'
    }
    healthObjective: 100
    impact: 'Standard'
    tags: {}
    signalGroups: {
      azureResource: {
        authenticationSetting: authenticationSetting.name
        azureResourceId: publicIp.id
        signals: [
          {
            name: 'vip-availability'
            signalKind: 'AzureResourceMetric'
            metricNamespace: 'microsoft.network/publicipaddresses'
            metricName: 'VipAvailability'
            timeGrain: 'PT15M'
            aggregationType: 'Maximum'
            displayName: 'Data Path Availability'
            refreshInterval: 'PT1M'
            dataUnit: 'Percent'
            evaluationRules: {
              degradedRule: {
                operator: 'LessThan'
                threshold: 100
              }
              unhealthyRule: {
                operator: 'LessThan'
                threshold: 95
              }
            }
          }
        ]
      }
    }
  }
}

resource natGatewayEntity 'microsoft.cloudhealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'nat-gateway'
  properties: {
    displayName: 'NAT Gateway'
    canvasPosition: {
      x: 600
      y: 400
    }
    icon: {
      iconName: 'Resource'
    }
    healthObjective: 100
    impact: 'Standard'
    tags: {}
    signalGroups: {
      azureResource: {
        authenticationSetting: authenticationSetting.name
        azureResourceId: natGateway.id
        signals: [
          {
            name: 'datapath-availability'
            signalKind: 'AzureResourceMetric'
            metricNamespace: 'microsoft.network/natgateways'
            metricName: 'Datapath Availability'
            timeGrain: 'PT1M'
            aggregationType: 'Average'
            displayName: 'Datapath Availability'
            refreshInterval: 'PT1M'
            dataUnit: 'Percent'
            evaluationRules: {
              degradedRule: {
                operator: 'LessThan'
                threshold: 100
              }
              unhealthyRule: {
                operator: 'LessThan'
                threshold: 99
              }
            }
          }
        ]
      }
    }
  }
}

resource rootToApplication 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'root-to-application'
  properties: {
    childEntityName: applicationEntity.name
    parentEntityName: healthModel.name
  }
}

resource applicationToStorage 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'application-to-storage'
  properties: {
    childEntityName: storageEntity.name
    parentEntityName: applicationEntity.name
  }
}

resource applicationToKeyVault 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'application-to-key-vault'
  properties: {
    childEntityName: keyVaultEntity.name
    parentEntityName: applicationEntity.name
  }
}

resource applicationToNat 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'application-to-nat-gateway'
  properties: {
    childEntityName: natGatewayEntity.name
    parentEntityName: applicationEntity.name
  }
}

resource publicIpToNat 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'publicip-to-nat-gateway'
  properties: {
    childEntityName: publicIpEntity.name
    parentEntityName: natGatewayEntity.name
  }
}

output healthModelName string = healthModel.name
output keyVaultName string = keyVault.name
output storageAccountName string = storageAccount.name
