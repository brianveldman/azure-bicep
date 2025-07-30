using 'main.bicep'

param __appRolesToAssign__ = [
  'User.ReadWrite.All'
]

param __resourceGroupName__ = 'rg-management-identities-prod-westeu-001'
param __managedIdentityName__ = 'id-management-identity-prod-westeu-001'
