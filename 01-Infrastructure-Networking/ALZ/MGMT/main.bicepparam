using 'main.bicep'

param __rootManagementGroupName__ = 'CloudTips'

param __rootLandingZone__ = [
  {
    id: __rootManagementGroupName__
    displayName: '${__rootManagementGroupName__} Root'
  }
]

param __midManagementGroups__ = [
  {
    id: 'Platform'
    displayName: 'Platform'
    parentId: __rootManagementGroupName__
  }
  {
    id: 'LandingZones'
    displayName: 'LandingZones'
    parentId: __rootManagementGroupName__
  }
  {
    id: 'Decommissioned'
    displayName: 'Decommissioned'
    parentId: __rootManagementGroupName__
  }
  {
    id: 'Sandbox'
    displayName: 'Sandbox'
    parentId: __rootManagementGroupName__
  }
]

param __platformLandingZones__ = [
  {
    id: 'Management'
    displayName: 'Management'
    parentId: __midManagementGroups__[0].id
  }
  {
    id: 'Identity'
    displayName: 'Identity'
    parentId: __midManagementGroups__[0].id
  }
  {
    id: 'Connectivity'
    displayName: 'Connectivity'
    parentId: __midManagementGroups__[0].id
  }
]

param __LandingZones__ = [
  {
    id: 'Corp'
    displayName: 'Corp'
    parentId: __midManagementGroups__[1].id
  }
  {
    id: 'Online'
    displayName: 'Online'
    parentId: __midManagementGroups__[1].id
  }
]


// param tier2 = {
//   id: 'Platform'
//   displayName: 'Platform'
//   parentId: 'CLOUDTIPS'
// }
