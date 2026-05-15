param (
    [CmdletBinding()]
    [parameter(Mandatory)]
    [string[]]$roles,
    [parameter(Mandatory)]
    [string]$subscriptionId
)

if ($null -eq $roles -or $roles.Count -eq 0) {
    Write-Error "Roles are required."
    exit
}

if ([string]::IsNullOrEmpty($subscriptionId)) {
    Write-Error "Subscription ID is required."
    exit
}

$scope = "/subscriptions/$subscriptionId"
Write-Output "Scope: $scope"

$rulesJson = Get-Content -Path "./rules.json" | ConvertFrom-Json

foreach ($role in $roles) {
    $roleData = $rulesJson.$role

    if ($null -eq $roleData) {
        Write-Error "No data found for role: $role"
        continue
    }

    $roleId = $roleData.RoleId
    $rules = $roleData.Rules

    if ($null -eq $rules) {
        Write-Error "No rules found for role: $role"
        continue
    }

    $getPolicy = Get-AzRoleManagementPolicyAssignment -Scope $scope | Where-Object { $_.Name -like "*$roleId*" }
    if ($null -eq $getPolicy) {
        Write-Error "No policy assignment found for role: $role"
        continue
    }

    $policyId = ($getPolicy.PolicyId -split "/")[6]

    if ([string]::IsNullOrEmpty($policyId)) {
        Write-Error "Policy ID is empty for role: $role"
        continue
    }

    # Log the policy ID for debugging
    Write-Output "Policy ID for $role - $policyId"

    $allRules = @()
    foreach ($rule in $rules) {
        $ruleType = "Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview." + $rule.ruleType
        $ruleObject = New-Object -TypeName $ruleType
        $ruleObject.isExpirationRequired = $rule.isExpirationRequired
        $ruleObject.maximumDuration = $rule.maximumDuration
        $ruleObject.enabledRule = $rule.enabledRule
        $ruleObject.id = $rule.id
        $ruleObject.ruleType = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Support.RoleManagementPolicyRuleType]($rule.ruleType)
        $ruleObject.targetOperation = $rule.targetOperation
        $allRules += $ruleObject
    }

    # Log the final converted rules before updating the policy
    Write-Output "Final Converted Rules for $role - $($allRules | ConvertTo-Json -Depth 10)"

    try {
        Update-AzRoleManagementPolicy -Scope $scope -Name $policyId -Rule $allRules
        Write-Output "PIM role assignment for $role updated successfully."
    } catch {
        Write-Error "Failed to update PIM role assignment for $role. Error: $_"
    }
}
