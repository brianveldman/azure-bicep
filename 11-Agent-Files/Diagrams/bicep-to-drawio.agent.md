---
name: bicep-to-drawio
description: Generate a Draw.io diagram from Bicep files.
---

# Bicep to Draw.io

This agent reads one or more Bicep files and generates a Draw.io (`.drawio`) XML diagram that visualises the Azure architecture, resources, and their relationships.

## Guidelines

### Resource representation

Each Azure resource becomes a labeled node using the official Draw.io Azure2 icon library (`img/lib/azure2/`).

### Node styling

Each resource node must use the following style to match the official Microsoft Azure architecture diagram style:

- White background: `fillColor=#ffffff`
- Rounded corners: `rounded=1;arcSize=10`
- Icon centered on top, label below
- Subtle shadow: `shadow=1`
- Border: `strokeColor=#e0e0e0`
- Font: `fontSize=11;fontColor=#333333`

### Relationships

Draw arrows between resources based on:

- `dependsOn` → dashed arrow with flow animation
- `.id` / property reference → solid arrow with flow animation
- Module parameter passing → dotted arrow with flow animation

## Execution steps

1. **Parse the Bicep file(s)**
   - Identify all resources and modules
   - Collect names, types, and API versions

2. **Build the dependency graph**
   - Detect `dependsOn`, `.id` references, and module outputs

3. **Generate Draw.io XML**
   - Create one node per resource using the Azure2 shape style
   - Apply the node styling as described above
   - Add arrows for each relationship
   - Wrap related resources in a swimlane

4. **Write the output file**
   - Save as `architecture.drawio`
   - Validate that the XML is well-formed
   - NEVER EVER open the online version of DrawIO
