targetScope = 'subscription'

param location string = 'westeurope'
param shortlocation string = substring(location,0, 2)
param createdby string = 'Brian Veldman'
param env string = 'prod'

param aztags object = {
  Environment: env
  CreatedBy: createdby
}

@description('Defining resource group parameters')
param networkrg string = 'rg-networking-${shortlocation}-${env}'

@description('Defining network parameters')
param azvnetname string  = 'vnet-res-${shortlocation}-${env}'
param azvnetaddresspace string = '10.150.0.0/22'

resource AzNetworkRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: networkrg
  location: location
  tags: aztags
}


@description('Modules')
module AzVNET './Modules/network.bicep' = {
  name: 'network-deployment'
  params: {
    location: location
    aztags: aztags
    azvnetname: azvnetname
    azvnetaddresspace: azvnetaddresspace
  }
  scope: AzNetworkRG
}
