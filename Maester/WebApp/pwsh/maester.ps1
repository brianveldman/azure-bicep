#Retrieve the default automation account variables
$appName           = Get-AutomationVariable -Name 'appName'
$resourceGroupName = Get-AutomationVariable -Name 'resourceGroupName'
$TenantId          = Get-AutomationVariable -Name 'tenantId'
$Tenant            = Get-AutomationVariable -Name 'tenant'

#Retrieve the test options
$enableTeamsTests     = [System.Convert]::ToBoolean((Get-AutomationVariable -Name 'enableTeamsTests'))
$enableExchangeTests  = [System.Convert]::ToBoolean((Get-AutomationVariable -Name 'enableExchangeTests'))
$enableComplianceTests = [System.Convert]::ToBoolean((Get-AutomationVariable -Name 'enableComplianceTests'))

#Setting up the connections
Connect-MgGraph -Identity
Connect-AzAccount -Identity

if ($enableExchangeTests) {
    Connect-ExchangeOnline -ManagedIdentity -Organization $Tenant -ShowBanner:$false
}

if ($enableComplianceTests) {
    $scToken = Get-AzAccessToken -ResourceUrl "https://ps.compliance.protection.outlook.com/"
    Connect-IPPSSession -AccessToken $scToken.Token -Organization $Tenant
}

if ($enableTeamsTests) {
    Connect-MicrosoftTeams -Identity
}

#Output folder and Maester
$date = (Get-Date).ToString("yyyyMMdd-HHmm")
$FileName = "MaesterReport$($date).zip"
$TempOutputFolder = Join-Path $env:TEMP $date
if (!(Test-Path $TempOutputFolder -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $TempOutputFolder | Out-Null
}

Set-Location $env:TEMP
if (!(Test-Path ".\maester-tests")) { New-Item -ItemType Directory -Path ".\maester-tests" | Out-Null }
Set-Location ".\maester-tests"

Install-MaesterTests .\tests
Invoke-Maester -OutputHtmlFile (Join-Path $TempOutputFolder "index.html")

Compress-Archive -Path (Join-Path $TempOutputFolder "*") -DestinationPath $FileName -Force

#Deploy to Azure Web App
Connect-AzAccount -Identity
Publish-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -ArchivePath $FileName -Force
