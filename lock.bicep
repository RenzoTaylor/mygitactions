param storageAccountName string = 'deployedfrombicep'
param location string = 'centralus'
param containerName string = 'testdirectoryb'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

}

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageAccountName}/default/${containerName}'
  properties: {
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccount
  ]
}
resource lock 'Microsoft.Authorization/locks@2016-09-01' = {
  name: '${storageAccountName}-lock'
  properties: {
    level: 'ReadOnly'
    notes: 'This lock prevents accidental deletion or modification of the storage account.'
  }
  scope: storageAccount
}
