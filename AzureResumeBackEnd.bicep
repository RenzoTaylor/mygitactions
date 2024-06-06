// Define parameters for the Cosmos DB account
param accountName string = 'azureresume'
param location string = resourceGroup().westus
param databaseName string = 'azureresumedatabase'
param containerName string = 'counter'
param partitionKeyPath string = '/id'

// Define the Cosmos DB account
resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-06-15' = {
  name: accountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
    enableFreeTier: true // Optional: Enable free tier
  }
}

// Define the SQL database within the Cosmos DB account
resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-04-15' = {
  name: '${cosmosDbAccount.name}/${databaseName}'
  properties: {
    resource: {
      id: databaseName
    }
  }
  dependsOn: [
    cosmosDbAccount
  ]
}

// Define the container within the database
resource cosmosDbContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-04-15' = {
  name: '${cosmosDbDatabase.name}/${containerName}'
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: [
          partitionKeyPath
        ]
        kind: 'Hash'
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
    }
  }
  dependsOn: [
    cosmosDbDatabase
  ]
}
