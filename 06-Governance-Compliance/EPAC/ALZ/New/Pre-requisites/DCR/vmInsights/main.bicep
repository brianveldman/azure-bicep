@description('Workspace Resource ID.')
param WorkspaceResourceId string

@description('Workspace Location.')
param WorkspaceLocation string

@description('This is the name of the Data Collection Rule(DCR) for VM Insights.')
@metadata({ displayName: 'Name of the Data Collection Rule(DCR)' })
param parVmInsights string = 'dcr-vminsights-prod'

module modVmInsights './modules/vmInsights.bicep' = {
  name: parVmInsights
  scope: resourceGroup(split(WorkspaceResourceId, '/')[2], split(WorkspaceResourceId, '/')[4])
  params: {
    parVmInsights: parVmInsights
    WorkspaceLocation: WorkspaceLocation
    WorkspaceResourceId: WorkspaceResourceId
  }
}
