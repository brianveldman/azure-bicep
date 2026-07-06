# Azure Bicep Repository

This repository contains Azure Bicep templates and PowerShell scripts for deploying and managing Azure resources.

## Structure

### 🏗️ 01-Infrastructure-Networking
- **[ALZ/](01-Infrastructure-Networking/ALZ/)** - Azure Landing Zones management group hierarchy
  - [MGMT/](01-Infrastructure-Networking/ALZ/MGMT/) - Management group configuration
  - [PIM/](01-Infrastructure-Networking/ALZ/PIM/) - Privileged Identity Management in ALZ scope
- **[Arc/](01-Infrastructure-Networking/Arc/)** - Azure Arc configurations for hybrid cloud
  - [Kubernetes/](01-Infrastructure-Networking/Arc/Kubernetes/) - Arc-enabled Kubernetes clusters
- **[Bastion/](01-Infrastructure-Networking/Bastion/)** - Secure RDP/SSH access configurations
- **[Networking/](01-Infrastructure-Networking/Networking/)** - Virtual networks, NSGs, and network infrastructure
  - [Bastion/](01-Infrastructure-Networking/Networking/Bastion/) - Network-integrated Bastion host
  - [CIDR-Functions/](01-Infrastructure-Networking/Networking/CIDR-Functions/) - CIDR calculation and address space functions
  - [MPS/](01-Infrastructure-Networking/Networking/MPS/) - Microsoft Purview/Private endpoint scenarios
  - [Network Security Perimeter/](01-Infrastructure-Networking/Networking/Network%20Security%20Perimeter/) - Network Security Perimeter configurations
  - [Network as Code/](01-Infrastructure-Networking/Networking/Network%20as%20Code/) - Infrastructure-as-code network deployments (VNet, Firewall)

### 🤖 02-AI-ML
- **[AI/](02-AI-ML/AI/)** - AI and ML services
  - [Computer Vision/](02-AI-ML/AI/Computer%20Vision/) - Computer Vision API implementations
  - [OpenAI/](02-AI-ML/AI/OpenAI/) - Azure OpenAI service integration with PowerShell
  - [SRE/](02-AI-ML/AI/SRE/) - Site Reliability Engineering for AI services
- **[CoPilot/](02-AI-ML/CoPilot/)** - Copilot integrations
  - [Custom Instructions/](02-AI-ML/CoPilot/Custom%20Instructions/) - Custom Copilot instructions
- **[Security Copilot/](02-AI-ML/Security%20Copilot/)** - Security Copilot integrations

### 🔒 03-Security-Identity
- **[Entra External ID/](03-Security-Identity/Entra%20External%20ID/)** - External identity configurations
  - [No-WAF/](03-Security-Identity/Entra%20External%20ID/No-WAF/) - CIAM without Web Application Firewall
- **[Entra ID/](03-Security-Identity/Entra%20ID/)** - Entra ID (Azure AD) templates
  - [Kerberos Authentication/](03-Security-Identity/Entra%20ID/%20Kerberos%20Authentication/) - Kerberos authentication with Storage accounts
  - [Federated Identity Credential/](03-Security-Identity/Entra%20ID/Federated%20Identity%20Credential/) - Workload identity federation
  - [Managed Identities/](03-Security-Identity/Entra%20ID/Managed%20Identities/) - Managed identity role assignments
- **[PIM/](03-Security-Identity/PIM/)** - Privileged Identity Management role automation
- **[MDFC/](03-Security-Identity/MDFC/)** - Microsoft Defender for Cloud security posture
- **[Multi-User Authorization/](03-Security-Identity/Multi-User%20Authorization/)** - Multi-user authorization patterns
- **[Maester/](03-Security-Identity/Maester/)** - Security testing and compliance automation
  - [AutomationAccount/](03-Security-Identity/Maester/AutomationAccount/) - Maester via Automation Account
  - [WebApp/](03-Security-Identity/Maester/WebApp/) - Maester via App Service web app

### 🚀 04-Compute-Containers
- **[ACS/](04-Compute-Containers/ACS/)** - Azure Container Service configurations
- **[Azure Container Apps/](04-Compute-Containers/Azure%20Container%20Apps/)** - Container Apps deployments
  - [DeepSeek/](04-Compute-Containers/Azure%20Container%20Apps/DeepSeek/) - DeepSeek model deployment on Container Apps
  - [Flexible/](04-Compute-Containers/Azure%20Container%20Apps/Flexible/) - Flexible Container Apps environment
  - [Microsoft Graph/Conditional Access Exporter/](04-Compute-Containers/Azure%20Container%20Apps/Microsoft%20Graph/Conditional%20Access%20Exporter/) - Conditional Access policy exporter via Graph API
- **[Azure Compute Gallery/](04-Compute-Containers/Azure%20Compute%20Gallery/)** - Compute gallery templates
- **[Azure Virtual Desktop/](04-Compute-Containers/Azure%20Virtual%20Desktop/)** - Azure Virtual Desktop deployments
  - [Session Host Config/](04-Compute-Containers/Azure%20Virtual%20Desktop/Session%20Host%20Config/) - AVD session host configuration
- **[Functions/](04-Compute-Containers/Functions/)** - Serverless Azure Functions
  - [Deployer/](04-Compute-Containers/Functions/Deployer/) - Function App with VNet integration
- **[Packer/](04-Compute-Containers/Packer/)** - Packer image building pre-requisite resources
- **[Local/](04-Compute-Containers/Local/)** - Local VM and development environment setup
  - [Aks/](04-Compute-Containers/Local/Aks/) - Local AKS cluster deployment
  - [VMs/](04-Compute-Containers/Local/VMs/) - Local virtual machine images and compute

### 🛠️ 05-DevOps-Automation
- **[Managed DevOps Pools/](05-DevOps-Automation/Managed%20DevOps%20Pools/)** - Azure Managed DevOps Pools
- **[Maintenance Configurations/](05-DevOps-Automation/Maintenance%20Configurations/)** - Maintenance window configurations
  - [Firewall/](05-DevOps-Automation/Maintenance%20Configurations/Firewall/) - Maintenance config for Azure Firewall
  - [VNet Gateway/](05-DevOps-Automation/Maintenance%20Configurations/VNet%20Gateway/) - Maintenance config for VNet Gateways
- **[Service Groups/](05-DevOps-Automation/Service%20Groups/)** - Service group configurations
  - [Resources/](05-DevOps-Automation/Service%20Groups/Resources/) - Service group resource relationship definitions

### 📋 06-Governance-Compliance
- **[EPAC/](06-Governance-Compliance/EPAC/)** - Enterprise Policy as Code for Azure Policy management
  - [ALZ/](06-Governance-Compliance/EPAC/ALZ/) - ALZ-aligned policy pre-requisites (DCR, UAMI)
  - [PolicyAssignment/](06-Governance-Compliance/EPAC/PolicyAssignment/) - Policy assignment templates
- **[FinOps/](06-Governance-Compliance/FinOps/)** - Financial operations and cost management
  - [AVM/](06-Governance-Compliance/FinOps/AVM/) - FinOps using Azure Verified Modules

### ✅ 07-Testing-Validation
- **[PSRule/](07-Testing-Validation/PSRule/)** - PSRule validation for IaC
- **[Pester/](07-Testing-Validation/Pester/)** - Pester testing framework
- **[PSDocs/](07-Testing-Validation/PSDocs/)** - PowerShell documentation generation

### 💾 08-Storage-Data
- **[storage.bicep](08-Storage-Data/storage.bicep)** - Storage account template

### 🧪 09-Experimental-Utilities
- **[Experimental Features/](09-Experimental-Utilities/Experimental%20Features/)** - Testing new Azure features
  - [localDeploy/](09-Experimental-Utilities/Experimental%20Features/localDeploy/) - Local deployment experiments (HTTP extension, Kubernetes)
- **[Scripting/](09-Experimental-Utilities/Scripting/)** - Utility scripts and helpers
  - [Azure Update Manager/](09-Experimental-Utilities/Scripting/Azure%20Update%20Manager/) - Update Manager automation scripts
  - [DeploymentScripts/](09-Experimental-Utilities/Scripting/DeploymentScripts/) - Inline deployment script templates

### 📚 10-Examples-Demos
- **[Bicep Features/](10-Examples-Demos/Bicep%20Features/)** - New Bicep language features and functions
  - **[Functions/](10-Examples-Demos/Bicep%20Features/Functions/)** - Built-in function examples
    - [like/](10-Examples-Demos/Bicep%20Features/Functions/like/) - Pattern matching with wildcards
    - [distinct/](10-Examples-Demos/Bicep%20Features/Functions/distinct/) - Array deduplication

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
