param __location__ string
param __ipAddressPrefixes__ array
param __subscriptionIds__ array
param _nspName_ string
param _nspLawName_ string
param _nspProfileName_ string

@description('Defining our NSP')
resource nsp 'Microsoft.Network/networkSecurityPerimeters@2023-08-01-preview' = {
  name: _nspName_
  location: __location__
}

@description('Defining our NSP Law')
resource nspLaw 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: _nspLawName_
  location: __location__
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

@description('Defining Diagnostic Settings for NSP')
resource nspDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'nsp-diagnostic-settings'
  scope: nsp
  properties: {
    workspaceId: nspLaw.id
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

@description('Defining our NSP Profile')
resource nspProfile 'Microsoft.Network/networkSecurityPerimeters/profiles@2023-08-01-preview' = {
  name: _nspProfileName_
  location: __location__
  parent: nsp
}

@description('Defining our NSP Profile Inbound - Address Prefix Rules')
resource nspProfileInboundAddressPrefixRules 'Microsoft.Network/networkSecurityPerimeters/profiles/accessRules@2023-08-01-preview' = {
  parent: nspProfile
  name: 'ALLOW_PIPS'
  properties: {
    direction: 'Inbound'
    addressPrefixes: __ipAddressPrefixes__
  }
}

@description('Defining our NSP Profile - Inbound Subscriptions')
resource nspProfileInboundSubscriptions 'Microsoft.Network/networkSecurityPerimeters/profiles/accessRules@2023-08-01-preview' = {
  parent: nspProfile
  name: 'ALLOW_OTHER_SUBSCRIPTIONS'
  properties: {
    direction: 'Inbound'
    subscriptions: __subscriptionIds__
  }
}
