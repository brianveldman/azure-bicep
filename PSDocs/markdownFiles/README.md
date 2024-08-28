# Networking as Code (NaC), VNets & Firewalls <3

This Bicep code deploys Networking as Code, including Hub & Spoke VNet, with peerings and Azure Firewall

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
__location__   | No       | Location to deploy resources
__env__        | Yes      | Environment
__cust__       | Yes      | Customer
__startDate__  | No       | Start date, used for tagging purposes
__author__     | No       | Bicep template created by
__website__    | No       | Blogger at
__loggingEnabled__ | No       | Decide if you want to enable logging for Azure Firewall
__vgwEnabled__ | No       | Decide if you want to deploy VNET Gateway

### __location__

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Location to deploy resources

- Default value: `westeurope`

### __env__

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Environment

- Allowed values: `dev`, `test`, `prod`

### __cust__

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Customer

### __startDate__

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Start date, used for tagging purposes

- Default value: `[utcNow('d-M-yyyy')]`

### __author__

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Bicep template created by

- Default value: `Brian Veldman`

### __website__

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Blogger at

- Default value: `CloudTips.nl`

### __loggingEnabled__

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Decide if you want to enable logging for Azure Firewall

- Default value: `True`

### __vgwEnabled__

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Decide if you want to deploy VNET Gateway

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
afwSubnet | string |
afwMgmtSubnet | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "main.json"
    },
    "parameters": {
        "__location__": {
            "value": "westeurope"
        },
        "__env__": {
            "value": ""
        },
        "__cust__": {
            "value": ""
        },
        "__startDate__": {
            "value": "[utcNow('d-M-yyyy')]"
        },
        "__author__": {
            "value": "Brian Veldman"
        },
        "__website__": {
            "value": "CloudTips.nl"
        },
        "__loggingEnabled__": {
            "value": true
        },
        "__vgwEnabled__": {
            "value": false
        }
    }
}
```
