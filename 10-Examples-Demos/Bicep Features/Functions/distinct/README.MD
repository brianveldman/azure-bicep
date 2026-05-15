# Bicep `distinct()` Function - Code Examples

## Example 1: Basic Array Deduplication

```bicep
param fruits array = [
  'apples'
  'bananas'
  'apples'
]

var normalizedFruits = distinct(fruits)

output outFruits array = normalizedFruits
// Returns: ['apples', 'bananas']
```

## Example 2: Deduplicate IP Addresses from IP Groups

```bicep
param ipGroups array = [
  {
    name: 'ipGroup1'
    ipAddresses: [
      '192.168.10.0/24'
    ]
  }
  {
    name: 'ipGroup2'
    ipAddresses: [
      '192.168.5.0/24'
    ]
  }
  {
    name: 'ipGroup3'
    ipAddresses: [
      '192.168.10.0/24'
    ]
  }
]

var ipAddresses = [for ipGroup in ipGroups: ipGroup.ipAddresses[0]]
var normalizedIpGroups = distinct(ipAddresses)

module ipGroup 'br/public:avm/res/network/ip-group:0.4.0' = [
  for ipGroup in normalizedIpGroups: {
    params: {
      name: ipGroup.name
      ipAddresses: ipGroup.ipAddresses
    }
  }
]
```

## Usage

These examples demonstrate:
- Removing duplicate values from arrays
- Deduplicating IP addresses before module deployment
- Combining `distinct()` with `for` loops to process arrays