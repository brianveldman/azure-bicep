@description('This is the name of the Data Collection Rule(DCR) for Defender for SQL.')
@metadata({ displayName: 'Name of the Data Collection Rule(DCR)' })
param userGivenDcrName string

@description('Workspace Location.')
param WorkspaceLocation string

@description('Enable collection of SQL queries for security research')
@metadata({ displayName: 'Enable collection of SQL queries for security research' })
param enableCollectionOfSqlQueriesForSecurityResearch bool

@description('Workspace Resource ID.')
param WorkspaceResourceId string

resource userGivenDcr 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: userGivenDcrName
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
            enableCollectionOfSqlQueriesForSecurityResearch: enableCollectionOfSqlQueriesForSecurityResearch
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
