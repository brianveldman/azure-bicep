$resourceGroupName = "rg-monitoring-prod-cnc-001"
$location = "canadacentral"
$randomNumber = Get-Random -Minimum 1000 -Maximum 9999

Write-Host "Creating resource group: $resourceGroupName in location: $location" -ForegroundColor Green
New-AzResourceGroup -Name $resourceGroupName -Location $location -ErrorAction Stop

Write-Host "Deploying Bicep template to resource group: $resourceGroupName" -ForegroundColor Green
New-AzResourceGroupDeployment -Name "deployment-$randomNumber" -TemplateFile "$PSScriptRoot/main.bicep" -Location $location -ResourceGroupName $resourceGroupName -ErrorAction Stop
