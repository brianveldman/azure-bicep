<#

.DESCRIPTION: AI Computer Vision EndPoint test with Image

#>

$aiCvName = "cv-ai-prod"
$uri = "https://$aiCvName.cognitiveservices.azure.com/computervision/imageanalysis:analyze?api-version=2023-02-01-preview&features=caption"
$headers = @{
    "Ocp-Apim-Subscription-Key" = ""
    "Content-Type" = "application/octet-stream"
}

#Retrieving the Image content and read the content as stream of bytes needed for API
$imageBytes = Get-Content ".\Dog.JPEG" -AsByteStream -Raw

# Make the POST request towards our AI EndPoint
$response = Invoke-WebRequest -Uri $uri -Method Post -Headers $headers -Body $imageBytes

# Getting response and Convert to JSON
$jsonContent = $response.Content | ConvertTo-Json

# Save the output to .JSON-file to investigation
$jsonContent | Out-File -FilePath ".\ai-details.json"