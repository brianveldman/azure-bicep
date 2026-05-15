# Managed Identity displayName
$managedIdentityDisplayName = 'aa-maester-prod-westeu-001'

# Exchange Online
$roleName = 'View-Only Recipients'
$organization = 'tenantName.onmicrosoft.com'

Connect-AzAccount -DeviceCode
$entraSp = Get-AzADServicePrincipal -Filter "displayName eq '$managedIdentityDisplayName'"
if(-not $entraSp){ throw "No servicePrincipal found with displayName $managedIdentityDisplayName" }

#===============================
# Exchange Online
#===============================
Connect-ExchangeOnline -Organization $organization

# Creates the Service Principal object in Exchange Online
New-ServicePrincipal -AppId $entraSp.AppId -ObjectId $entraSp.Id -DisplayName $entraSp.DisplayName

# Assigns the 'View-Only Configuration' role to the Managed Identity
New-ManagementRoleAssignment -Role $roleName -App $entraSp.DisplayName

#===============================
# Purview Security and Compliance
#===============================

Connect-IPPSSession -Organization $organization

# Creates the Service Principal object in Exchange Online
New-ServicePrincipal -AppId $entraSp.AppId -ObjectId $entraSp.Id -DisplayName $entraSp.DisplayName

# Assigns the 'View-Only Configuration' role to the Managed Identity
New-ManagementRoleAssignment -Role $roleName -App $entraSp.DisplayName