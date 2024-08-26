<##
.DESCRIPTION
    This script is used to export Az resources to JSON and then generate a PSRule report based on the exported Az resources JSON.

.SYNOPSIS
    PSRule_IaC_Inflight.ps1

##>

# Exports Az resources to JSON
Export-AzRuleData -OutputPath 'inflight/'

# Lets generate a PSRule report based on our exported Az Resources JSON
Invoke-PSRule -InputPath '.\inflight\35480d6c-351a-4894-b2e6-b36dddb33a85.json' -Module 'PSRule.Rules.Azure' | Export-CSV './export/PSRule_Report.csv'