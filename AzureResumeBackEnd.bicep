param name string
param location string
param locationName string
param defaultExperience string
param isZoneRedundant string

resource cosmosDbAccount 'Microsoft.DocumentDb/databaseAccounts@2024-05-15-preview' = {
  kind: 'GlobalDocumentDB'
  name: name
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        id: '${name}-${location}'
        failoverPriority: 0
        locationName: locationName
        isZoneRedundant: isZoneRedundant
      }
    ]
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        backupStorageRedundancy: 'Zone'
      }
    }
    isVirtualNetworkFilterEnabled: false
    virtualNetworkRules: []
    ipRules: []
    minimalTlsVersion: 'Tls12'
    capabilities: []
    capacityMode: 'Serverless'
    enableFreeTier: false
    capacity: {
      totalThroughputLimit: 4000
    }
  }
  tags: {
    defaultExperience: defaultExperience
    'hidden-cosmos-mmspecial': ''
  }
}
