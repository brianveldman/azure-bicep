param __location__ string
param _backupResourceName_ string
param _resourceGuardName_ string

@description('Deployment of the Azure Recovery Services Vault')
resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2025-02-01' = {
  name: _backupResourceName_
  location: __location__
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

@description('Deployment of the Resource Guard for Backup')
resource resourceGuard 'Microsoft.DataProtection/resourceGuards@2025-07-01' = {
  name: _resourceGuardName_
  location: __location__
}

@description('Deployment of the Backup Resource Guard Proxy for linking the Resource Guard to the Recovery Services Vault')
resource guardProxy 'Microsoft.RecoveryServices/vaults/backupResourceGuardProxies@2025-02-01' = {
  name: 'VaultProxy'
  parent: recoveryServicesVault
  properties: {
    resourceGuardResourceId: resourceGuard.id
  }
}
