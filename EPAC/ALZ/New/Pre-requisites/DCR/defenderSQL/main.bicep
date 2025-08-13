@description('Workspace Resource ID.')
param WorkspaceResourceId string

@description('Workspace Location.')
param WorkspaceLocation string

@description('This is the name of the Data Collection Rule(DCR) for Defender for SQL.')
@metadata({ displayName: 'Name of the Data Collection Rule(DCR)' })
param userGivenDcrName string = 'dcr-defendersql-prod'

@description('Enable collection of SQL queries for security research')
@metadata({ displayName: 'Enable collection of SQL queries for security research' })
param enableCollectionOfSqlQueriesForSecurityResearch bool = false

module userGivenDcr './modules/defenderSql.bicep' = {
  name: userGivenDcrName
  scope: resourceGroup(split(WorkspaceResourceId, '/')[2], split(WorkspaceResourceId, '/')[4])
  params: {
    userGivenDcrName: userGivenDcrName
    WorkspaceLocation: WorkspaceLocation
    enableCollectionOfSqlQueriesForSecurityResearch: enableCollectionOfSqlQueriesForSecurityResearch
    WorkspaceResourceId: WorkspaceResourceId
  }
}
