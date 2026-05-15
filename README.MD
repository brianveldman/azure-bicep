# Azure Bicep Repository

This repository contains Azure Bicep templates and PowerShell scripts for deploying and managing Azure resources.

## Structure

### 🏗️ 01-Infrastructure-Networking
- **[ALZ/](01-Infrastructure-Networking/ALZ/)** - Azure Landing Zones management group hierarchy
- **[Arc/](01-Infrastructure-Networking/Arc/)** - Azure Arc configurations for hybrid cloud
- **[Bastion/](01-Infrastructure-Networking/Bastion/)** - Secure RDP/SSH access configurations
- **[Networking/](01-Infrastructure-Networking/Networking/)** - Virtual networks, NSGs, and network infrastructure

### 🤖 02-AI-ML
- **[AI/](02-AI-ML/AI/)** - AI and ML services
  - Computer Vision/ - Computer Vision API implementations
  - OpenAI/ - Azure OpenAI service integration with PowerShell
  - SRE/ - Site Reliability Engineering for AI services
- **[CoPilot/](02-AI-ML/CoPilot/)** - Copilot integrations
- **[Security Copilot/](02-AI-ML/Security%20Copilot/)** - Security Copilot integrations

### 🔒 03-Security-Identity
- **[Entra External ID/](03-Security-Identity/Entra%20External%20ID/)** - External identity configurations
- **[Entra ID/](03-Security-Identity/Entra%20ID/)** - Entra ID (Azure AD) templates
- **[PIM/](03-Security-Identity/PIM/)** - Privileged Identity Management role automation
- **[MDFC/](03-Security-Identity/MDFC/)** - Microsoft Defender for Cloud security posture
- **[Multi-User Authorization/](03-Security-Identity/Multi-User%20Authorization/)** - Multi-user authorization patterns
- **[Maester/](03-Security-Identity/Maester/)** - Security testing and compliance automation

### 🚀 04-Compute-Containers
- **[ACS/](04-Compute-Containers/ACS/)** - Azure Container Service configurations
- **[Azure Container Apps/](04-Compute-Containers/Azure%20Container%20Apps/)** - Container Apps deployments
- **[Azure Compute Gallery/](04-Compute-Containers/Azure%20Compute%20Gallery/)** - Compute gallery templates
- **[Functions/](04-Compute-Containers/Functions/)** - Serverless Azure Functions
- **[Packer/](04-Compute-Containers/Packer/)** - Packer image building
- **[Local/](04-Compute-Containers/Local/)** - Local VM and development environment setup

### 🛠️ 05-DevOps-Automation
- **[Managed DevOps Pools/](05-DevOps-Automation/Managed%20DevOps%20Pools/)** - Azure Managed DevOps Pools
- **[Maintenance Configurations/](05-DevOps-Automation/Maintenance%20Configurations/)** - Maintenance window configurations
- **[Service Groups/](05-DevOps-Automation/Service%20Groups/)** - Service group configurations

### 📋 06-Governance-Compliance
- **[EPAC/](06-Governance-Compliance/EPAC/)** - Enterprise Policy as Code for Azure Policy management
- **[FinOps/](06-Governance-Compliance/FinOps/)** - Financial operations and cost management

### ✅ 07-Testing-Validation
- **[PSRule/](07-Testing-Validation/PSRule/)** - PSRule validation for IaC
- **[Pester/](07-Testing-Validation/Pester/)** - Pester testing framework
- **[PSDocs/](07-Testing-Validation/PSDocs/)** - PowerShell documentation generation

### 💾 08-Storage-Data
- **[storage/](08-Storage-Data/storage/)** - Storage account templates

### 🧪 09-Experimental-Utilities
- **[Experimental Features/](09-Experimental-Utilities/Experimental%20Features/)** - Testing new Azure features
- **[Scripting/](09-Experimental-Utilities/Scripting/)** - Utility scripts and helpers

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