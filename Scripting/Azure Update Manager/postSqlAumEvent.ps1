# Make sure that we are using eventGridEvent for parameter binding in Azure function.
param($eventGridEvent, $TriggerMetadata)

Connect-AzAccount -Identity

# Install the Resource Graph module from PowerShell Gallery
# Install-Module -Name Az.ResourceGraph

$maintenanceRunId = $eventGridEvent.data.CorrelationId
$resourceSubscriptionIds = $eventGridEvent.data.ResourceSubscriptionIds
$serviceName = 'MSSQL$SQLEXPRESS'

if ($resourceSubscriptionIds.Count -eq 0) {
    Write-Output "Resource subscriptions are not present."
    break
}

Write-Output "Querying ARG to get machine details [MaintenanceRunId=$maintenanceRunId][ResourceSubscriptionIdsCount=$($resourceSubscriptionIds.Count)]"

$argQuery = @"
    maintenanceresources 
    | where type =~ 'microsoft.maintenance/applyupdates'
    | where properties.correlationId =~ '$($maintenanceRunId)'
    | where id has '/providers/microsoft.compute/virtualmachines/'
    | project id, resourceId = tostring(properties.resourceId)
    | order by id asc
"@

Write-Output "Arg Query Used: $argQuery"

$allMachines = [System.Collections.ArrayList]@()
$skipToken = $null

do {
    $res = Search-AzGraph -Query $argQuery -First 1000 -SkipToken $skipToken -Subscription $resourceSubscriptionIds
    $skipToken = $res.SkipToken
    $allMachines.AddRange($res.Data)
} while ($skipToken -ne $null -and $skipToken.Length -ne 0)
if ($allMachines.Count -eq 0) {
    Write-Output "No Machines were found."
    break
}

$jobIDs = New-Object System.Collections.Generic.List[System.Object]

$allMachines | ForEach-Object {
    $vmId = $_.resourceId

    $split = $vmId -split "/";
    $subscriptionId = $split[2]; 
    $rg = $split[4];
    $name = $split[8];

    Write-Output ("Subscription Id: " + $subscriptionId)

    $newJob = Start-ThreadJob -ScriptBlock {
        param($rg, $name, $subscriptionId, $maintenanceRunId, $serviceName)

        $mute = Set-AzContext -Subscription $subscriptionId
        $vm = Get-AzVM -ResourceGroupName $rg -Name $name -Status -DefaultProfile $mute

        # Define the script content to start the service
        $scriptContent = {
            param($serviceName)
            # Ensure logging folder exists on C: drive (C:\aum)
            $logFolder = 'C:\AUM'
            if (-not (Test-Path -Path $logFolder)) {
                New-Item -ItemType Directory -Path $logFolder -Force
            }

            # Generate log file name with date and time
            $currentDateTime = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
            $logFile = Join-Path $logFolder "OperationLog-$currentDateTime.txt"

            # Log start of the process
            'Starting service start process...' | Out-File -FilePath $logFile -Append

            # Start the service
            try {
                $service = Get-Service -Name $serviceName -ErrorAction Stop
                if ($service.Status -eq 'Stopped') {
                    Start-Service -Name $serviceName
                    'Service started successfully.' | Out-File -FilePath $logFile -Append
                } else {
                    'Service was already running.' | Out-File -FilePath $logFile -Append
                }
            } catch {
                'Error starting service: ' + $_ | Out-File -FilePath $logFile -Append
            }

            'Process completed.' | Out-File -FilePath $logFile -Append
        }

        # Creating Scriptblock
        $Script = [scriptblock]::create($scriptContent)

        # Execute the remote command on the VM
        try {
            Write-Output "Executing inline script to start service on VM [$name]"
            Invoke-AzVMRunCommand -Name $name -ResourceGroupName $rg -CommandId 'RunPowerShellScript' -ScriptString $Script -Parameter @{ serviceName = $serviceName }
        } catch {
            Write-Output "Failed to execute script on VM [$name]: $_"
        }
    } -ArgumentList $rg, $name, $subscriptionId, $maintenanceRunId, $serviceName

    $jobIDs.Add($newJob.Id)
}

$jobsList = $jobIDs.ToArray()
if ($jobsList) {
    Write-Output "Waiting for machines to finish executing scripts..."
    Wait-Job -Id $jobsList
}

foreach($id in $jobsList) {
    $job = Get-Job -Id $id
    if ($job.Error) {
        Write-Output $job.Error
    }
}

Write-Output "All operations completed."
