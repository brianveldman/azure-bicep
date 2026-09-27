#Deployment of the resourceGroup which will hold our resources
New-AzResourceGroup -Name "rg-aca-prod-westeu-001" -Location westeurope

#Deployment of the Azure Container App Sandbox environment
New-AzResourceGroupDeployment -Name casAcaDeploy -ResourceGroupName "rg-aca-prod-westeu-001" -TemplateFile .\main.bicep
