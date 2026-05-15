# Bicep `like()` Function - Code Examples

## Example 1: Basic Pattern Matching

```bicep
param parInput string = 'Hello, World!'
 
output outOutput bool = like(parInput, '*World*')
// Returns: true
```

## Example 2: Conditional Resource Lock

```bicep
param parEnvironment string

var workloadName = 'xyz-${parEnvironment}'
var applyLock = like(workloadName, '*prod*')

resource lock 'Microsoft.Authorization/locks@2020-05-01' = if (applyLock) {
  name: 'cannot-delete'
  properties: {
    level: 'CanNotDelete'
    notes: 'Production protection'
  }
}
```

## Example 3: Conditional Module Deployment

```bicep
@allowed([
  'prod'
  'test'
  'acc'
])
param parEnvironment string

module appi 'br/public:avm/res/insights/component:0.7.1' = if (like(parEnvironment, '*prod*')) {
  params: {
    name: 'appi-${parEnvironment}'
    workspaceResourceId: 'idHere'
  }
}
```

## Usage

These examples demonstrate:
- Pattern matching with wildcards (`*`)
- Conditional resource deployment based on environment
- Protection of production resources with locks
- Selective module deployment using `like()` function
