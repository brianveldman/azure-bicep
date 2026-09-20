# Connect using Managed Identity
Connect-AzAccount -Identity

# Define export folder (one folder per day)
$today = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date -Format "HH-mm-ss"

$exportRoot = Join-Path "/scripts/AzureChanges" $today

# Create folder if it doesn't exist
New-Item -ItemType Directory -Force -Path $exportRoot | Out-Null

# Resource Graph query
$query = @"
resourcechanges
| extend timestamp = todatetime(properties.changeAttributes.timestamp)
| where timestamp >= ago(24h)
| project
    timestamp,
    targetResourceId = tostring(properties.targetResourceId),
    changeType = tostring(properties.changeType),
    changedBy = tostring(properties.changeAttributes.changedBy),
    operation = tostring(properties.changeAttributes.operation),
    correlationId = tostring(properties.changeAttributes.correlationId),
    changes = properties.changes
| order by timestamp desc
"@

# Retrieve changes
$changes = Search-AzGraph -Query $query

# Export JSON
$filePath = Join-Path $exportRoot "AzureChanges_$timestamp.json"

$changes |
    ConvertTo-Json -Depth 20 |
    Out-File -FilePath $filePath -Encoding utf8

Write-Host "Exported $($changes.Count) changes."
Write-Host "File: $filePath"
