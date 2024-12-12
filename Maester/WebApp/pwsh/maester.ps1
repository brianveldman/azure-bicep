$appName = "app-maester-prod"
$resourceGroupName = "rg-maester-prod"

#Connect to Microsoft Graph with Mi
Connect-MgGraph -Identity

#create output folder
$date = (Get-Date).ToString("yyyyMMdd-HHmm")
$FileName = "MaesterReport" + $date + ".zip"

$TempOutputFolder = $env:TEMP + $date
if (!(Test-Path $TempOutputFolder -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $TempOutputFolder
}

#Run Maester report
cd $env:TEMP
md maester-tests
cd maester-tests
Install-MaesterTests .\tests

#Invoke Maester for HTML page
Invoke-Maester -OutputHtmlFile "$TempOutputFolder\index.html"

# Create the zip file
Compress-Archive -Path "$TempOutputFolder\*" -DestinationPath $FileName

# Connect Az Account using MI
Connect-AzAccount -Identity

#Publish to Azure Web App <3
Publish-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -ArchivePath $FileName -Force
