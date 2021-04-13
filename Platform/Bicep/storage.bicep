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

param deploymentScriptTimestamp string = utcNow()
param indexDocument string = 'index.html'
param errorDocument404Path string = '404.html'

// Define variables
var stgname = 'sa${resourcePrefix}${environment}${storageenv}'

var storageAccountContributorRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab') // This is the Storage Account Contributor role, which is the minimum role permission we can give. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#:~:text=17d1049b-9a84-46fb-8f53-869881c3d3ab

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
