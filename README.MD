# Azure Bicep Repository

This repository contains Azure Bicep templates and PowerShell scripts for deploying and managing Azure resources.

## Bicep Index
This index covers all 98 Bicep files, including 49 deployment entry points. Main templates link directly to `main.bicep`; link text uses solution names.

### 🏗️ 01-Infrastructure-Networking
- [ALZ / Management Group Configuration](01-Infrastructure-Networking/ALZ/MGMT/main.bicep)
- [ALZ / Privileged Identity Management](01-Infrastructure-Networking/ALZ/PIM/main.bicep)
- [Bastion](01-Infrastructure-Networking/Bastion/main.bicep)
- [Networking / Bastion](01-Infrastructure-Networking/Networking/Bastion/main.bicep)
- [Networking / CIDR Functions / Part 1](01-Infrastructure-Networking/Networking/CIDR-Functions/Part%201/main.bicep)
- [Networking / CIDR Functions / Part 2](01-Infrastructure-Networking/Networking/CIDR-Functions/Part%202/main.bicep)
- [Networking / Explicit Proxy](01-Infrastructure-Networking/Networking/Explicit%20Proxy/main.bicep)
- [Networking / MPS](01-Infrastructure-Networking/Networking/MPS/main.bicep)
- [Networking / Network Security Perimeter](01-Infrastructure-Networking/Networking/Network%20Security%20Perimeter/main.bicep)
- [Networking / Network as Code](01-Infrastructure-Networking/Networking/Network%20as%20Code/main.bicep)

Supporting Bicep files:
- [ALZ / PIM / Modules / PIM](01-Infrastructure-Networking/ALZ/PIM/modules/pim.bicep)
- [Networking / Bastion / Modules / Network as Code](01-Infrastructure-Networking/Networking/Bastion/modules/nac.bicep)
- [Networking / CIDR Functions / Part 1 / Explanation](01-Infrastructure-Networking/Networking/CIDR-Functions/Part%201/Explanation.bicep)
- [Networking / CIDR Functions / Part 1 / Modules / Network](01-Infrastructure-Networking/Networking/CIDR-Functions/Part%201/Modules/network.bicep)
- [Networking / CIDR Functions / Part 2 / Modules / Network](01-Infrastructure-Networking/Networking/CIDR-Functions/Part%202/modules/network.bicep)
- [Networking / MPS / Modules / Virtual Network](01-Infrastructure-Networking/Networking/MPS/modules/vnet.bicep)
- [Networking / Network Security Perimeter / Modules / Network Security Perimeter](01-Infrastructure-Networking/Networking/Network%20Security%20Perimeter/modules/nsp.bicep)
- [Networking / Network As Code / Modules / Azure Firewall](01-Infrastructure-Networking/Networking/Network%20as%20Code/modules/afw.bicep)
- [Networking / Network As Code / Modules / Network as Code](01-Infrastructure-Networking/Networking/Network%20as%20Code/modules/nac.bicep)

### 🤖 02-AI-ML
- [AI / Computer Vision](02-AI-ML/AI/Computer%20Vision/main.bicep)
- [AI / Model Router](02-AI-ML/AI/Model%20Router/main.bicep)
- [AI / OpenAI](02-AI-ML/AI/OpenAI/main.bicep)
- [AI / Site Reliability Engineering](02-AI-ML/AI/SRE/main.bicep)
- [Security Copilot](02-AI-ML/Security%20Copilot/main.bicep)

Supporting Bicep files:
- [AI / Computer Vision / Modules / Computer Vision](02-AI-ML/AI/Computer%20Vision/modules/ai-cv.bicep)
- [AI / Model Router / Modules / Ai](02-AI-ML/AI/Model%20Router/modules/ai.bicep)
- [AI / Openai / Modules / OpenAI](02-AI-ML/AI/OpenAI/modules/oai.bicep)
- [Security Copilot / Modules / Security](02-AI-ML/Security%20Copilot/modules/security.bicep)

### 🔒 03-Security-Identity
- [Entra External ID / No-WAF](03-Security-Identity/Entra%20External%20ID/No-WAF/main.bicep)
- [Entra ID / Kerberos Authentication / Storage](03-Security-Identity/Entra%20ID/%20Kerberos%20Authentication/Storage/main.bicep)
- [Entra ID / Federated Identity Credential](03-Security-Identity/Entra%20ID/Federated%20Identity%20Credential/main.bicep)
- [Entra ID / Managed Identities / Assign Permissions](03-Security-Identity/Entra%20ID/Managed%20Identities/Assign%20Permissions/main.bicep)
- [Microsoft Defender for Cloud / Services](03-Security-Identity/MDFC/Services/main.bicep)
- [Maester / Automation Account](03-Security-Identity/Maester/AutomationAccount/main.bicep)
- [Maester / Web App](03-Security-Identity/Maester/WebApp/main.bicep)
- [Multi-User Authorization](03-Security-Identity/Multi-User%20Authorization/main.bicep)

Supporting Bicep files:
- [Entra External Id / No-WAF / Modules / External ID](03-Security-Identity/Entra%20External%20ID/No-WAF/modules/ciam.bicep)
- [Entra Id / Kerberos Authentication / Storage / Modules / Storage Account](03-Security-Identity/Entra%20ID/%20Kerberos%20Authentication/Storage/modules/sa.bicep)
- [Entra Id / Kerberos Authentication / Storage / Readers and Writers](03-Security-Identity/Entra%20ID/%20Kerberos%20Authentication/Storage/readersWriters.bicep)
- [Maester / Automationaccount / Modules / Advanced Automation Account](03-Security-Identity/Maester/AutomationAccount/modules/aa-advanced.bicep)
- [Maester / Automationaccount / Modules / Automation Account](03-Security-Identity/Maester/AutomationAccount/modules/aa.bicep)
- [Maester / Webapp / Modules / Advanced Automation Account](03-Security-Identity/Maester/WebApp/modules/aa-advanced.bicep)
- [Maester / Webapp / Modules / Automation Account](03-Security-Identity/Maester/WebApp/modules/aa.bicep)
- [Maester / Webapp / Modules / App-service](03-Security-Identity/Maester/WebApp/modules/app-service.bicep)
- [Multi-user Authorization / Modules / Backup](03-Security-Identity/Multi-User%20Authorization/modules/backup.bicep)
- [PIM / PIM](03-Security-Identity/PIM/pim.bicep)

### 🚀 04-Compute-Containers
- [Azure Container Service](04-Compute-Containers/ACS/main.bicep)
- [Azure Compute Gallery](04-Compute-Containers/Azure%20Compute%20Gallery/main.bicep)
- [Azure Container Apps / Azure PowerShell](04-Compute-Containers/Azure%20Container%20Apps/Azure%20PowerShell/main.bicep)
- [Azure Container Apps / DeepSeek](04-Compute-Containers/Azure%20Container%20Apps/DeepSeek/main.bicep)
- [Azure Container Apps / Flexible Environment](04-Compute-Containers/Azure%20Container%20Apps/Flexible/main.bicep)
- [Azure Container Apps / Conditional Access Exporter](04-Compute-Containers/Azure%20Container%20Apps/Microsoft%20Graph/Conditional%20Access%20Exporter/main.bicep)
- [Azure Container Apps / Sandboxes](04-Compute-Containers/Azure%20Container%20Apps/Sandboxes/main.bicep)
- [Azure Virtual Desktop / Session Host Configuration](04-Compute-Containers/Azure%20Virtual%20Desktop/Session%20Host%20Config/main.bicep)
- [Azure Virtual Machines / GPU](04-Compute-Containers/Azure%20Virtual%20Machines/GPU/main.bicep)
- [Azure Functions / Deployer](04-Compute-Containers/Functions/Deployer/main.bicep)
- [Local / AKS](04-Compute-Containers/Local/Aks/main.bicep)
- [Local / Virtual Machine Compute](04-Compute-Containers/Local/VMs/compute/main.bicep)
- [Packer / Prerequisite Resources](04-Compute-Containers/Packer/prereq-resources/main.bicep)

Supporting Bicep files:
- [ACS / Modules / Acs](04-Compute-Containers/ACS/modules/acs.bicep)
- [Azure Container Apps / Azure Powershell / Modules / Aca](04-Compute-Containers/Azure%20Container%20Apps/Azure%20PowerShell/modules/aca.bicep)
- [Azure Container Apps / Deepseek / Modules / Ai](04-Compute-Containers/Azure%20Container%20Apps/DeepSeek/modules/ai.bicep)
- [Azure Container Apps / Microsoft Graph / Conditional Access Exporter / Modules / Aca](04-Compute-Containers/Azure%20Container%20Apps/Microsoft%20Graph/Conditional%20Access%20Exporter/modules/aca.bicep)
- [Azure Virtual Desktop / Session Host Config / Modules / Avd](04-Compute-Containers/Azure%20Virtual%20Desktop/Session%20Host%20Config/modules/avd.bicep)
- [Functions / Deployer / Virtual Network](04-Compute-Containers/Functions/Deployer/vnet.bicep)
- [Local / Aks / Modules / AKS](04-Compute-Containers/Local/Aks/modules/aks.bicep)
- [Local / VMs / Compute / Modules / Virtual Machine](04-Compute-Containers/Local/VMs/compute/modules/vm.bicep)
- [Local / VMs / Images / Local VM Image](04-Compute-Containers/Local/VMs/images/localVmImage.bicep)

### 🛠️ 05-DevOps-Automation
- [Maintenance Configurations / Firewall](05-DevOps-Automation/Maintenance%20Configurations/Firewall/main.bicep)
- [Maintenance Configurations / VNet Gateway](05-DevOps-Automation/Maintenance%20Configurations/VNet%20Gateway/main.bicep)
- [Managed DevOps Pools](05-DevOps-Automation/Managed%20DevOps%20Pools/main.bicep)
- [Service Groups / Resources](05-DevOps-Automation/Service%20Groups/Resources/main.bicep)

Supporting Bicep files:
- [Maintenance Configurations / Firewall / Modules / Maintenance Configuration](05-DevOps-Automation/Maintenance%20Configurations/Firewall/modules/mc.bicep)
- [Maintenance Configurations / Vnet Gateway / Modules / Maintenance Configuration](05-DevOps-Automation/Maintenance%20Configurations/VNet%20Gateway/modules/mc.bicep)
- [Managed Devops Pools / Modules / Managed DevOps Pool](05-DevOps-Automation/Managed%20DevOps%20Pools/modules/mdp.bicep)
- [Service Groups / Resources / Modules / Relationship](05-DevOps-Automation/Service%20Groups/Resources/modules/relationship.bicep)
- [Service Groups / Example](05-DevOps-Automation/Service%20Groups/example.bicep)

### 📋 06-Governance-Compliance
- [EPAC / ALZ / Defender for SQL](06-Governance-Compliance/EPAC/ALZ/New/Pre-requisites/DCR/defenderSQL/main.bicep)
- [EPAC / ALZ / VM Insights](06-Governance-Compliance/EPAC/ALZ/New/Pre-requisites/DCR/vmInsights/main.bicep)
- [EPAC / ALZ / User-Assigned Managed Identity](06-Governance-Compliance/EPAC/ALZ/New/Pre-requisites/UAMI/main.bicep)

Supporting Bicep files:
- [Epac / ALZ / New / Pre-requisites / Dcr / Defender SQL / Modules / Defender for SQL](06-Governance-Compliance/EPAC/ALZ/New/Pre-requisites/DCR/defenderSQL/modules/defenderSql.bicep)
- [Epac / ALZ / New / Pre-requisites / Dcr / VM Insights / Modules / VM Insights](06-Governance-Compliance/EPAC/ALZ/New/Pre-requisites/DCR/vmInsights/modules/vmInsights.bicep)
- [Epac / ALZ / New / Pre-requisites / UAMI / Modules / User-Assigned Managed Identity](06-Governance-Compliance/EPAC/ALZ/New/Pre-requisites/UAMI/modules/uami.bicep)
- [Finops / Avm / FinOps](06-Governance-Compliance/FinOps/AVM/finops.bicep)

### ✅ 07-Testing-Validation
- [PSDocs](07-Testing-Validation/PSDocs/main.bicep)
- [PSRule / Test](07-Testing-Validation/PSRule/test/main.bicep)
- [Pester](07-Testing-Validation/Pester/main.bicep)

Supporting Bicep files:
- [Psdocs / Modules / Azure Firewall](07-Testing-Validation/PSDocs/modules/afw.bicep)
- [Psdocs / Modules / Network as Code](07-Testing-Validation/PSDocs/modules/nac.bicep)
- [Psrule / Test / Modules / Storage Account](07-Testing-Validation/PSRule/test/modules/storageAccount.bicep)
- [Pester / Modules / Storage Account](07-Testing-Validation/Pester/modules/storage-account.bicep)
- [Pester / Modules / Web App](07-Testing-Validation/Pester/modules/web-app.bicep)

### 💾 08-Storage-Data

Supporting Bicep files:
- [Storage](08-Storage-Data/storage.bicep)

### 🧪 09-Experimental-Utilities
- [Experimental Features / Local Deployment / HTTP](09-Experimental-Utilities/Experimental%20Features/localDeploy/http/main.bicep)
- [Deployment Scripts / Storage](09-Experimental-Utilities/Scripting/DeploymentScripts/Storage/main.bicep)

Supporting Bicep files:
- [Experimental Features / Local Deployment / K8s](09-Experimental-Utilities/Experimental%20Features/localDeploy/k8s.bicep)
- [Scripting / Deploymentscripts / Storage / Modules / Storage Account](09-Experimental-Utilities/Scripting/DeploymentScripts/Storage/modules/sa.bicep)

### 📊 12-Azure-Monitor
- [Azure Monitor / Health Models](12-Azure-Monitor/Health%20Models/main.bicep) - Application health model with availability signals for Storage, Key Vault, NAT Gateway, and Public IP.

## Key Features

### 🏢 Enterprise-Scale Landing Zones
Complete Azure Landing Zone hierarchy with root management groups, platform zones, and landing zones for Corp and Online workloads.

### 🔐 Security Automation
Automated security testing with Maester, PIM automation, MDFC integration, and PSRule validation for infrastructure as code.

### 🤖 AI Services
Azure OpenAI integration, Computer Vision APIs, and SRE patterns for AI workloads.

### 💰 Cost Management
FinOps templates for cost optimization, budget alerts, and financial governance.

## Prerequisites

- Azure CLI or PowerShell Az module
- Bicep CLI
- Appropriate Azure permissions (Owner/Contributor at subscription/management group level)

## Contributing

1. Follow Bicep best practices
2. Include parameter files (`.bicepparam`)
3. Add documentation for complex deployments
4. Run PSRule validation before committing

## Resources

- [Azure Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [Azure Landing Zones](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/)
- [Enterprise-Scale Architecture](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/)
