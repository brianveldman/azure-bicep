<##

.DESCRIPTION
    This script is used to generate documentation for Azure Bicep files using PSDocs module.

.PARAMETER BicepFilePath
    The path to the Bicep file that you want to generate documentation for.

.PARAMETER OutputFolderPath
    The path to the folder where you want to save the generated documentation.

##>

function Invoke-BicepDocumentation {
    param (
        [string]$bicepFilePath,
        [string]$outputFolderPath
    )
    
    # Install the PSDocs module from the PowerShell Gallery
    if (-not (Get-Module -Name 'PSDocs.Azure' -ListAvailable)) {
        Install-Module -Name 'PSDocs.Azure' -Repository PSGallery -Scope CurrentUser
    } else {
        Write-Host "PSDocs.Azure module is already installed <3" -ForegroundColor Green
    }

    # Bicep Build ARM Template
    az bicep build --file $bicepFilePath

    # Invoke PSDocs to generate documentation
    Invoke-PSDocument -Module PSDocs.Azure -InputObject .\main.json -OutputPath $OutputFolderPath -InstanceName README

}

Invoke-BicepDocumentation -bicepFilePath ".\main.bicep" -outputFolderPath ".\markdownFiles"