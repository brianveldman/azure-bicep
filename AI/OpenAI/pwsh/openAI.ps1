function Invoke-oAI {
    param (
        $question
    )

    $oaiEndPoint = "https://oai-ct-prod.openai.azure.com"
    $oaiDeploymentModelName = "oai-gpt4-model-prod"

    # Check if already signed in
    $account = Get-AzContext
    if (-not $account) {
        Write-Output "Not connected to Azure, please sign in."
        Connect-AzAccount 
    }

    # Get the token for OpenAI
    $tokenRequest = Get-AzAccessToken -ResourceUrl "https://cognitiveservices.azure.com" 
    $token = $tokenRequest.Token

    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    # Constructing body for request
    $body = @{
        messages = @(
            @{
                role = "user"
                content = $question
            }
        )
    } | ConvertTo-Json
    # Making the endpoint call to OpenAI <3
    $response = Invoke-RestMethod -Uri "$oaiEndPoint/openai/deployments/$oaiDeploymentModelName/chat/completions?api-version=2024-02-01" -Headers $headers -Method Post -Body $body
    $aiAnswer = $response.choices[0].message.content
    $aiAnswer
}

Invoke-oAi -question "Who is Brian Veldman from CloudTips.nl?"