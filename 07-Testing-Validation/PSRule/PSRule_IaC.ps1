<##
.DESCRIPTION
    This script is used to install PSRule and Rules for Infrastructure as Code (IaC) validation.
    The script will install PSRule, PSRule.Rules.Azure and PSRule.Rules.CAF modules.
    The script will then run PSRule against the test folder.

.SYNOPSIS
    PSRule_IaC.ps1

##>

# Install PSRule and Rules
Install-Module -Name "PSRule" -Force
Install-Module -Name "PSRule.Rules.Azure"
Install-Module -Name "PSRule.Rules.CAF"

# Run PSRule with Invoke
Invoke-PSRule -InputPath 'test/'

# Run PSRule with Assert
Assert-PSRule -InputPath 'test/'