
# Define the test suite
Describe 'Bicep Web App Validation' {
    # Define the test for SKU
    It 'should have httpsOnly' {
        # Find the web app resource in the JSON output
        $webApps = $template.resources | Where-Object { $_.type -eq 'Microsoft.Web/sites' }

        # Validate that each web app httpsOnly
        foreach ($webApp in $webApps) {
            $webApp.properties.httpsOnly | Should -Be $true
        }
    }
}