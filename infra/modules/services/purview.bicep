// This template is used to create a Purview account.
targetScope = 'resourceGroup'

// Parameters
param location string
param tags object
param subnetId string
param purviewName string
param privateDnsZoneIdPurview string
param privateDnsZoneIdStorageBlob string
param privateDnsZoneIdStorageQueue string
param privateDnsZoneIdEventhubNamespace string

// Variables
var purviewPrivateEndpointNamePortal = '${purview.name}-portal-private-endpoint'
var purviewPrivateEndpointNameAccount = '${purview.name}-account-private-endpoint'
var purviewPrivateEndpointNameBlob = '${purview.name}-blob-private-endpoint'
var purviewPrivateEndpointNameQueue = '${purview.name}-queue-private-endpoint'
var purviewPrivateEndpointNameNamespace = '${purview.name}-namespace-private-endpoint'
var purviewRegions = [
  'brazilsouth'
  'canadacentral'
  'eastus'
  'eastus2'
  'southcentralus'
  'southeastasia'
  'westeurope'
]

// Resources
// Resources
resource purview 'Microsoft.Purview/accounts@2020-12-01-preview' = {
  name: purviewName
  location: contains(purviewRegions, location) ? location : 'westeurope'
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Standard'
    capacity: 4
  }
  properties: {
    cloudConnectors: {}
    friendlyName: purviewName
    managedResourceGroupName: purviewName
    publicNetworkAccess: 'Disabled'
  }
}

resource purviewPrivateEndpointPortal 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: purviewPrivateEndpointNamePortal
  location: location
  tags: tags
  properties: {
    manualPrivateLinkServiceConnections: []
    privateLinkServiceConnections: [
      {
        name: purviewPrivateEndpointNamePortal
        properties: {
          groupIds: [
            'portal'
          ]
          privateLinkServiceId: purview.id
          requestMessage: ''
        }
      }
    ]
    subnet: {
      id: subnetId
    }
  }
}

resource purviewPrivateEndpointPortalARecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-11-01' = {
  parent: purviewPrivateEndpointPortal
  name: 'aRecord'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${purviewPrivateEndpointPortal.name}-arecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdPurview
        }
      }
    ]
  }
}

resource purviewPrivateEndpointAccount 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: purviewPrivateEndpointNameAccount
  location: location
  tags: tags
  properties: {
    manualPrivateLinkServiceConnections: []
    privateLinkServiceConnections: [
      {
        name: purviewPrivateEndpointNameAccount
        properties: {
          groupIds: [
            'account'
          ]
          privateLinkServiceId: purview.id
          requestMessage: ''
        }
      }
    ]
    subnet: {
      id: subnetId
    }
  }
}

resource purviewPrivateEndpointAccountARecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-11-01' = {
  parent: purviewPrivateEndpointAccount
  name: 'aRecord'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${purviewPrivateEndpointAccount.name}-arecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdPurview
        }
      }
    ]
  }
}

resource purviewPrivateEndpointBlob 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: purviewPrivateEndpointNameBlob
  location: location
  tags: tags
  properties: {
    manualPrivateLinkServiceConnections: []
    privateLinkServiceConnections: [
      {
        name: purviewPrivateEndpointNameBlob
        properties: {
          groupIds: [
            'blob'
          ]
          privateLinkServiceId: purview.properties.managedResources.storageAccount
          requestMessage: ''
        }
      }
    ]
    subnet: {
      id: subnetId
    }
  }
}

resource purviewPrivateEndpointBlobARecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-11-01' = {
  parent: purviewPrivateEndpointBlob
  name: 'aRecord'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${purviewPrivateEndpointBlob.name}-arecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdStorageBlob
        }
      }
    ]
  }
}

resource purviewPrivateEndpointQueue 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: purviewPrivateEndpointNameQueue
  location: location
  tags: tags
  properties: {
    manualPrivateLinkServiceConnections: []
    privateLinkServiceConnections: [
      {
        name: purviewPrivateEndpointNameQueue
        properties: {
          groupIds: [
            'queue'
          ]
          privateLinkServiceId: purview.properties.managedResources.storageAccount
          requestMessage: ''
        }
      }
    ]
    subnet: {
      id: subnetId
    }
  }
}

resource purviewPrivateEndpointQueueARecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-11-01' = {
  parent: purviewPrivateEndpointQueue
  name: 'aRecord'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${purviewPrivateEndpointQueue.name}-arecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdStorageQueue
        }
      }
    ]
  }
}

resource purviewPrivateEndpointNamespace 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: purviewPrivateEndpointNameNamespace
  location: location
  tags: tags
  properties: {
    manualPrivateLinkServiceConnections: []
    privateLinkServiceConnections: [
      {
        name: purviewPrivateEndpointNameNamespace
        properties: {
          groupIds: [
            'namespace'
          ]
          privateLinkServiceId: purview.properties.managedResources.eventHubNamespace
          requestMessage: ''
        }
      }
    ]
    subnet: {
      id: subnetId
    }
  }
}

resource purviewPrivateEndpointNamespaceARecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-11-01' = {
  parent: purviewPrivateEndpointNamespace
  name: 'aRecord'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${purviewPrivateEndpointNamespace.name}-arecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdEventhubNamespace
        }
      }
    ]
  }
}

// Outputs
output purviewId string = purview.id