using 'main.bicep'

param parCustomerName = 'ct'
param parEnvironmentName = 'prod'
param parLocation = 'swedencentral'
param parSolutionName = 'deepseek'
param parContainerEnvironmentName = 'cae-${parCustomerName}-${parEnvironmentName}-${parLocation}-001'
param parLogAnalyticsName = 'law-${parCustomerName}-${parEnvironmentName}-${parLocation}-001'
param parContainerName = 'ca-${parCustomerName}-${parEnvironmentName}-${parLocation}-001'
