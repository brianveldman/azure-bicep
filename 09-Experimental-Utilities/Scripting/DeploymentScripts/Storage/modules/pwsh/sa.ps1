<#

.DESCRIPTION: Deployment Script via Bicep <3

#>

param (
    [string]$saName,
    [string]$saContainerName,
    [string]$rgName
)

#Connect to Azure
Connect-AzAccount -Identity

#Get working context
$saContext = Get-AzStorageAccount -Name $saName -ResourceGroupName $rgName
$workingContext = $saContext.Context

#Deployment Azure Storage Container
New-AzStorageContainer -Name $saContainerName -Permission Blob -Context $workingContext