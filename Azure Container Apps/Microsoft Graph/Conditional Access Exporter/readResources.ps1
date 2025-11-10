# Connect to Microsoft Graph
Connect-MgGraph

# Client Service Principal ID of the Container App Job Managed Identity
$clientSpId = ""

# Get the Microsoft Graph Service Principal ID
$graphSp = Get-MgServicePrincipal -Filter "appId eq '00000003-0000-0000-c000-000000000000'"
if (-not $graphSp) { throw "Graph service principal not found" }

# Assign the Policy.Read.All app role to the client service principal
$role = $graphSp.AppRoles | Where-Object { $_.Value -eq "Policy.Read.All" -and $_.AllowedMemberTypes -contains "Application" }
if (-not $role) { throw "Selected app role not found on Graph or not of type Application" }

# Validate client service principal
$clientSp = Get-MgServicePrincipal -ServicePrincipalId $clientSpId -ErrorAction Stop
if (-not $clientSp) { throw "Client service principal not found" }

# Checking values
"clientSpId   : $($clientSp.Id)"
"resourceId   : $($graphSp.Id)"
"appRoleId    : $($role.Id)"

# Create the app role assignment
New-MgServicePrincipalAppRoleAssignment `
  -ServicePrincipalId $clientSp.Id `
  -PrincipalId $clientSp.Id `
  -ResourceId $graphSp.Id `
  -AppRoleId $role.Id
