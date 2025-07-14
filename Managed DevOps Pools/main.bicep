metadata name = 'Managed DevOps Pools as Code <3'
metadata description = 'This Bicep code deploys Managed DevOps Pools including NAT gateway for forced egress via a public IP address.'
metadata owner = 'Brian Veldman'

targetScope = 'subscription'

@description('Defing our input parameters')
param __env__ string
param __cust__ string
param __location__ string
param __devOpsOrganizationName__ string
param __devOpsProjectName__ string

@description('Defining our variables')
var _mdpResourceGroupName_ = 'rg-mdp-${__cust__}-${__env__}'
var _devCenterName_ = 'devcenter-${__cust__}-${__env__}'
var _devCenterProjectName_ = 'devcenter-${__cust__}-project-${__env__}'
var _vnetManagedDevOpsPoolName_ = 'vnet-mdp-${__cust__}-${__env__}'
var _pipNatGatewayName_ = 'pip-ng-mdp-${__cust__}-${__env__}'
var _natGatewayName_ = 'ng-mdp-${__cust__}-${__env__}'
var _managedDevOpsPoolName_ = 'mdp-${__cust__}-${__env__}'

@description('Resource Group Deployment')
resource mdpResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: _mdpResourceGroupName_
  location: __location__
}

@description('Module Deployment')
module mdp './modules/mdp.bicep' = {
  name: 'mdp-module-deployment'
  params: {
    __location__: __location__
    _devCenterName_: _devCenterName_
    _devCenterProjectName_: _devCenterProjectName_
    _managedDevOpsPoolName_: _managedDevOpsPoolName_
    _vnetManagedDevOpsPoolName_: _vnetManagedDevOpsPoolName_
    _pipNatGatewayName_: _pipNatGatewayName_
    _natGatewayName_: _natGatewayName_
    __devOpsOrganizationName__: __devOpsOrganizationName__
    __devOpsProjectName__: __devOpsProjectName__
  }
  scope: mdpResourceGroup
}
