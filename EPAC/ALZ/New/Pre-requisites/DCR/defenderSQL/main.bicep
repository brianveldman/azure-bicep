@description('Workspace Resource ID.')
param parparWorkspaceResourceId string

@description('Workspace Location.')
param parparWorkspaceLocation string

@description('This is the name of the Data Collection Rule(DCR) for Defender for SQL.')
@metadata({ displayName: 'Name of the Data Collection Rule(DCR)' })
param parDcrDefenderSql string = 'dcr-defendersql-prod'

@description('Enable collection of SQL queries for security research')
@metadata({ displayName: 'Enable collection of SQL queries for security research' })
param parEnableCollectionOfSqlQueriesForSecurityResearch bool = false

module modDefenderSql './modules/defenderSql.bicep' = {
  name: parDcrDefenderSql
  scope: resourceGroup(split(parWorkspaceResourceId, '/')[2], split(parWorkspaceResourceId, '/')[4])
  params: {
    parDcrDefenderSql: parDcrDefenderSql
    parWorkspaceLocation: parWorkspaceLocation
    enableCollectionOfSqlQueriesForSecurityResearch: enableCollectionOfSqlQueriesForSecurityResearch
    parWorkspaceResourceId: parWorkspaceResourceId
  }
}
