@description('This is the name of the Data Collection Rule(DCR) for Defender for SQL.')
@metadata({ displayName: 'Name of the Data Collection Rule(DCR)' })
param parDcrDefenderSql string

@description('Workspace Location.')
param parWorkspaceLocationstring

@description('Enable collection of SQL queries for security research')
@metadata({ displayName: 'Enable collection of SQL queries for security research' })
param parEnableCollectionOfSqlQueriesForSecurityResearch bool

@description('Workspace Resource ID.')
param WorkspaceResourceId string

resource DefenderSql 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: parDcrDefenderSql
  location: WorkspaceLocation
  properties: {
    description: 'Data collection rule for Defender for SQL.'
    dataSources: {
      extensions: [
        {
          extensionName: 'MicrosoftDefenderForSQL'
          name: 'MicrosoftDefenderForSQL'
          streams: [
            'Microsoft-DefenderForSqlAlerts'
            'Microsoft-DefenderForSqlLogins'
            'Microsoft-DefenderForSqlTelemetry'
            'Microsoft-DefenderForSqlScanEvents'
            'Microsoft-DefenderForSqlScanResults'
            'Microsoft-SqlAtpStatus-DefenderForSql'
          ]
          extensionSettings: {
            parEnableCollectionOfSqlQueriesForSecurityResearch: parEnableCollectionOfSqlQueriesForSecurityResearch
          }
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: WorkspaceResourceId
          name: 'LogAnalyticsDest'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-DefenderForSqlAlerts'
          'Microsoft-DefenderForSqlLogins'
          'Microsoft-DefenderForSqlTelemetry'
          'Microsoft-DefenderForSqlScanEvents'
          'Microsoft-DefenderForSqlScanResults'
          'Microsoft-SqlAtpStatus-DefenderForSql'
        ]
        destinations: [
          'LogAnalyticsDest'
        ]
      }
    ]
  }
}
