
# Define the test suite
Describe 'Bicep Storage Account Validation' {
    # Define the test for SKU
    It 'should have GRS SKU in Bicep file' {
        # Find the storage account resource in the JSON output
        $storageAccounts = $template.resources | Where-Object { $_.type -eq 'Microsoft.Storage/storageAccounts' }

        # Validate that each storage account SKU is set to GRS
        foreach ($storageAccount in $storageAccounts) {
            $storageAccount.sku.name | Should -Be 'Standard_GRS'
        }
    }

    # Define the test for supportsHttpsTrafficOnly
    It 'should have supportsHttpsTrafficOnly set to true' {
        # Find the storage account resource in the JSON output
        $storageAccounts = $template.resources | Where-Object { $_.type -eq 'Microsoft.Storage/storageAccounts' }

        # Validate that supportsHttpsTrafficOnly is set to true
        foreach ($storageAccount in $storageAccounts) {
            $storageAccount.properties.supportsHttpsTrafficOnly | Should -Be $true
        }
    }

    # Define the test for allowBlobPublicAccess
    It 'should have allowBlobPublicAccess set to false' {
        # Find the storage account resource in the JSON output
        $storageAccounts = $template.resources | Where-Object { $_.type -eq 'Microsoft.Storage/storageAccounts' }

        # Validate that allowBlobPublicAccess is set to false
        foreach ($storageAccount in $storageAccounts) {
            $storageAccount.properties.allowBlobPublicAccess | Should -Be $false 
        }
    }
}