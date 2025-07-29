# General Template Guidelines
* Use Azure Bicep for deploying resources to Microsoft Azure. Always provide Bicep code when creating templates.
* Ensure security best practices, such as firewall settings, TLS, and private endpoints.
* Consider cost when crafting templates. Provide multiple SKUs/sizes using the `@description` decorator.

# Bicep Template Principles
* Use 'West Europe' as the deployment location.
* Set the target scope to 'resourceGroup'.
- Begin Bicep files with metadata including name, description, owner, and version number. For example: 
```bicep 
metadata name = 'exampleName' 
metadata description = 'exampleDescription' 
metadata owner = 'Brian Veldman' 
metadata versionnumber = '1.0.0'
```
* Add the @description decorator at the parameters section, variables section, and for independent Bicep resources.
* Use location, env, and tags as standard input parameters.
* Prefix and suffix parameters with double underscores. For example, __location__.
* Prefix and suffix variables with single underscores. For example, _storageAccountName_.
