
#Define variables
location="westeurope"
templateFile="main.bicep"
parametersFile="main.bicepparam"

#Deploy the Bicep file
az deployment tenant create --location $location --template-file $templateFile --parameters $parametersFile