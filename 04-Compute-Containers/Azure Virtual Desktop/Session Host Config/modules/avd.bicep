@description('Our Input parameters')
param parLocation string
param parEnvironment string
param parLandingZone string
param parNumber string

@secure()
param parLocalAdminPasswordSecretName string
param parLocalAdminUsernameSecretName string
param parTags object
param varShortEnvironment string

@description('Defining our Variables')
var hostPoolName = 'vdpool-${parLandingZone}-${parEnvironment}-${varShortEnvironment}-${parNumber}'
var workspaceName = 'vdws-${parLandingZone}-${parEnvironment}-${varShortEnvironment}-${parNumber}'
var applicationGroupName = 'vdag-${parLandingZone}-${parEnvironment}-${varShortEnvironment}-${parNumber}'
var keyVaultName = 'kv-${parLandingZone}-${parEnvironment}-${varShortEnvironment}-${parNumber}'
var virtualNetworkName = 'vnet-${parLandingZone}-${parEnvironment}-${varShortEnvironment}-${parNumber}'
var uamiName = 'uami-${parLandingZone}-${parEnvironment}-${varShortEnvironment}-${parNumber}'

@description('Creating Key Vault for storing secrets')
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: parLocation
  tags: parTags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
  }
}

@description('Creating Key Vault Secrets for Domain Admin and Local Admin Credentials')
resource localadminUsernameSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'localAdminUsername'
  properties: {
    value: parLocalAdminUsernameSecretName
  }
}

resource localadminPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'localAdminPassword'
  properties: {
    value: parLocalAdminPasswordSecretName
  }
}

@description('Creating Virtual Network for AVD Deployment')
resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworkName
  location: parLocation
  tags: parTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.150.0.0/23'
      ]
    }
    subnets: [
      {
        name: 'snet-avd'
        properties: {
          addressPrefixes: [
            '10.150.1.0/24'
          ]
        }
      }
    ]
  }
}

@description('Creating User Assigned Managed Identity for Host Pool')
resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-01-31-preview' = {
  name: uamiName
  location: parLocation
  tags: parTags
}

@description('Creating Host Pool with Session Host Configuration')
#disable-next-line BCP081 // Due the fact it is a preview API version don't want a FP
resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2026-01-01-preview' = {
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uami.id}': {}
    }
  }
  name: hostPoolName
  location: parLocation
  tags: parTags
  properties: {
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType: 'Desktop'
    managementType: 'Automated'
  }
  dependsOn: [
    keyVault
  ]
}

@description('VM Contributor Role Assignment on Resource Group level for the UAMI')
module virtualMachineContributorRaUami 'br/public:avm/res/authorization/role-assignment/rg-scope:0.1.1' = {
  params: {
    principalId: uami.properties.principalId
    roleDefinitionIdOrName: '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
    principalType: 'ServicePrincipal'
  }
  dependsOn: [
    hostPool
  ]
}

@description('Key Vault Secrets User Role Assignment on Resource Group level for the UAMI')
module secretsUserRaUami 'br/public:avm/res/authorization/role-assignment/rg-scope:0.1.1' = {
  params: {
    principalId: uami.properties.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '4633458b-17de-408a-b874-0445c86b69e6'
  }
  dependsOn: [
    hostPool
  ]
}

@description('Reader Role Assignment on Resource Group level for the UAMI')
module readerRaUami 'br/public:avm/res/authorization/role-assignment/rg-scope:0.1.1' = {
  params: {
    principalId: uami.properties.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  }
  dependsOn: [
    hostPool
  ]
}

@description('Virtualization Contributor Role Assignment on Resource Group level for the UAMI')
module virtualizationContributorRaUami 'br/public:avm/res/authorization/role-assignment/rg-scope:0.1.1' = {
  params: {
    principalId: uami.properties.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'a959dbd1-f747-45e3-8ba6-dd80f235f97c'
  }
  dependsOn: [
    hostPool
  ]
}

@description('Creating Session Host Configuration for the Host Pool')
#disable-next-line BCP081 // Due the fact it is a preview API version don't want a FP
resource sessionHostConfiguration 'Microsoft.DesktopVirtualization/hostPools/sessionHostConfigurations@2026-01-01-preview' = {
  parent: hostPool
  name: 'default'
  properties: {
    diskInfo: {
      managedDisk: {
        type: 'Premium_LRS'
      }
    }
    domainInfo: {
      joinType: 'AzureActiveDirectory'
      azureActiveDirectoryInfo: {
        mdmProviderGuid: '0000000a-0000-0000-c000-000000000000'
      }
    }
    imageInfo: {
      marketplaceInfo: {
        exactVersion: '26200.8655.260609'
        offer: 'office-365'
        publisher: 'MicrosoftWindowsDesktop'
        sku: 'win11-25h2-avd-m365'
      }
      type: 'Marketplace'
    }
    networkInfo: {
      subnetId: vnet.properties.subnets[0].id
    }
    securityInfo: {
      secureBootEnabled: true
      type: 'TrustedLaunch'
      vTpmEnabled: true
    }

    vmAdminCredentials: {
      passwordKeyVaultSecretUri: 'https://${keyVaultName}${environment().suffixes.keyvaultDns}/secrets/localAdminPassword'
      usernameKeyVaultSecretUri: 'https://${keyVaultName}${environment().suffixes.keyvaultDns}/secrets/localAdminUsername'
    }
    vmLocation: parLocation
    vmNamePrefix: 'vd'
    vmResourceGroup: resourceGroup().name
    vmSizeId: 'Standard_E8ds_v5'
  }
  dependsOn: [
    virtualizationContributorRaUami
  ]
}

@description('Creating Session Host Management for the Host Pool')
#disable-next-line BCP081 // Due the fact it is a preview API version don't want a FP
resource sessionHostManagement 'Microsoft.DesktopVirtualization/hostPools/sessionHostManagements@2026-01-01-preview' = {
  parent: hostPool
  name: 'default'
  properties: {
    failedSessionHostCleanupPolicy: 'KeepAll'
    provisioning: {
      instanceCount: 1
      canaryPolicy: 'Auto'
      setDrainMode: false
    }
    scheduledDateTimeZone: 'UTC'
    update: {
      deleteOriginalVm: true
      maxVmsRemoved: 1
      logOffDelayMinutes: 2
      logOffMessage: 'You will be signed out'
    }
  }
  dependsOn: [
    sessionHostConfiguration
  ]
}

@description('Creating Application Group for the Host Pool')
#disable-next-line BCP081 // Due the fact it is a preview API version don't want a FP
resource applicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2026-01-01-preview' = {
  name: applicationGroupName
  location: parLocation
  tags: parTags
  properties: {
    applicationGroupType: 'Desktop'
    hostPoolArmPath: hostPool.id
    friendlyName: 'Desktop Application Group'
  }
  dependsOn: [
    sessionHostConfiguration
  ]
}
@description('Creating Workspace for the Application Group')
#disable-next-line BCP081 // Due the fact it is a preview API version don't want a FP
resource workspace 'Microsoft.DesktopVirtualization/workspaces@2026-01-01-preview' = {
  name: workspaceName
  location: parLocation
  tags: parTags
  properties: {
    friendlyName: 'Azure Virtual Desktop Workspace'
    applicationGroupReferences: [
      applicationGroup.id
    ]
  }
}
