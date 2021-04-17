// Set the parameters and default values, if required.
param environment string
param storageenv string
param resourcePrefix string
param location string = resourceGroup().location

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Standard_RAGRS'
])
param skuName string

// Define variables
var stgname = 'sa${resourcePrefix}${environment}${storageenv}'

// Deploy Storage Account
resource storage 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: stgname
  location: location
  kind:'StorageV2'
  sku:{
    name: skuName
  }
  properties: {
    minimumTlsVersion:'TLS1_2'
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    networkAcls:{
      bypass:'AzureServices'
      defaultAction:'Allow'
      virtualNetworkRules:[]
    }
    supportsHttpsTrafficOnly: true
  }
}

// Output the Static Website Hostname from Storage Account deployment.
output staticWebsiteHostName string = replace(replace(storage.properties.primaryEndpoints.web, 'https://', ''), '/', '')
