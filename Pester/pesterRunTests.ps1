<##

.DESCRIPTION
    This script is used to run Pester tests for Bicep files.

.PARAMETER bicepDirectory
    The directory containing the Bicep files to test.

##>

function Invoke-BicepUnitTests {
    param (
        [string]$bicepDirectory,
        [switch]$Debugging
    )
    
    # Install the Pester module from the PowerShell Gallery
    if (-not (Get-Module -Name 'Pester' -ListAvailable)) {
        Install-Module -Name 'Pester' -Repository PSGallery -Scope CurrentUser
    } else {
        Write-Host "[+] Pester module is already installed <3" -ForegroundColor Green
    }

    # Import the Pester module
    Import-Module -Name Pester
    
    # Import the Pester configuration
    $pesterConfiguration = Import-PowerShellDataFile -Path './pesterConfiguration.psd1'

    # Create Pester containers for the test scripts
    $pesterContainers = @()
    foreach ($testPath in $pesterConfiguration.Run.TestPaths) {
        $pesterContainers += New-PesterContainer -Path $testPath
    }

    # Add the containers to the configuration
    $pesterConfiguration.Run.Container = $pesterContainers

    # Get all the Bicep files in the directory
    $bicepFilePaths = Get-ChildItem -Path $bicepDirectory -Filter *.bicep -Recurse | Select-Object -ExpandProperty FullName

    foreach ($bicepFilePath in $bicepFilePaths) {
        # Bicep Build ARM Template for Pester
        az bicep build --file $bicepFilePath

        # Collecting JSON template for validation
        $templatePath = [System.IO.Path]::ChangeExtension($bicepFilePath, ".json")
        Write-Host "templatePath is = $templatePath"

        # Needed for our tests
        $template = Get-Content -Raw -Path $templatePath | ConvertFrom-Json

        # Run the tests
        Invoke-Pester -Configuration $pesterConfiguration
        #Invoke-Pester -Script $pesterTestScripts -Output Detailed

        if(-not $Debugging) {
            # Clean up the generated ARM template
            Remove-Item -Path $templatePath -Force
        }
    }
}