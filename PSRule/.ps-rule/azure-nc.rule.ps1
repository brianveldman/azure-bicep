#Rule for naming conventions Azure Storage Accounts
Rule 'Azure.SA.Prefix' -Type 'Microsoft.Storage/storageAccounts' {
    $Assert.Match($TargetObject, 'name', '^sa.*$', $True)
}

#Rule for naming conventions Azure Resource Groups
Rule 'Azure.RG.Prefix' -Type 'Microsoft.Resources/resourceGroups' {
    $Assert.Match($TargetObject, 'name', '^rg.*$', $True)
}