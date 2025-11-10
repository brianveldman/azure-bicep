# Connect using managed identity
Connect-MgGraph -Identity

# Retrieve all conditional access policies
$policies = Get-MgIdentityConditionalAccessPolicy

# Defining export root
$timestamp = (Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')
$exportRoot = "/scripts/CA_$timestamp"

# Create folder
New-Item -ItemType Directory -Force -Path $exportRoot | Out-Null

# Loop through to all policies and write seperate .JSON
foreach ($policy in $policies) {
    $safeName = ($policy.DisplayName -replace '[^a-zA-Z0-9-_]', '_')
    $filePath = Join-Path $exportRoot "$safeName.json"

    $policy | ConvertTo-Json -Depth 10 | Out-File -FilePath $filePath -Encoding utf8
    Write-Host "Exported: $filePath"
}

Write-Host "Export complete. Files saved under: $exportRoot"
