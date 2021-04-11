// This file operates at subscription level. This is an example of a modular deployment. It creates a resource group then deploys a storage account via another bicep file to that resource group.

// this file can only be deployed at a subscription scope
targetScope = 'subscription'

// Set the parameters, along with defaults per recommended practices
param environment string = 'blog'
param storageenv1 string = 'prod'
param storageenv2 string = 'stage'
param location string = 'northeurope'
param resourcePrefix string = 'irishtechie'
param skuName string = 'Standard_RAGRS'
param cdnProfileName string = 'cdnp-${resourcePrefix}-${environment}'
param endPointName string = 'cdne-${resourcePrefix}-${environment}'
param endPointNameStage string = 'cdne-${resourcePrefix}-${environment}-stage'

var storageAccountHostName  = storageAcc.outputs.staticWebsiteHostName
var storageAccountHostNameStage  = storageAccStage.outputs.staticWebsiteHostName

// deploy a resource group to the subscription scope
resource NewRG 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'rg-${resourcePrefix}-${environment}'
  location: location
}

// Call a separate bicep file to deploy storage resource.
module storageAcc 'storage.bicep' = {
  name: 'storageAcc'
  // Change deployment context to RG
  scope: resourceGroup(NewRG.name)
  params: {
    resourcePrefix: resourcePrefix
    environment: environment
    storageenv: storageenv1
    skuName: skuName
  }
}

module storageAccStage 'storage.bicep' = {
  name: 'storageAccStage'
  // Change deployment context to RG
  scope: resourceGroup(NewRG.name)
  params: {
    resourcePrefix: resourcePrefix
    environment: environment
    storageenv: storageenv2
    skuName: skuName
  }
}

module cdnProfile 'cdnprofile.bicep' = {
  name: 'cdnProfile'
  // Change deployment context to RG
  scope: resourceGroup(NewRG.name)
  params: {
    cdnProfileName: cdnProfileName
    location: location
  }
}

module cdnEndpoint 'cdnendpoint.bicep' = {
  name: 'cdnEndpoint'
  // Change deployment context to RG
  scope: resourceGroup(NewRG.name)
  params: {
    cdnProfileName: cdnProfileName
    endPointName: endPointName
    storageAccountHostName: storageAccountHostName
    location: location
  }
}

module cdnEndpointStage 'cdnendpoint.bicep' = {
  name: 'cdnEndpointStage'
  // Change deployment context to RG
  scope: resourceGroup(NewRG.name)
  params: {
    cdnProfileName: cdnProfileName
    endPointName: endPointNameStage
    storageAccountHostName: storageAccountHostNameStage
    location: location
  }
}

module cdneCustomDomain 'cdnecustomdomain.bicep' = {
  name: 'cdneCustomDomain'
  dependsOn: [
    cdnEndpoint
    cdnEndpointStage
  ]
  // Change deployment context to RG
  scope: resourceGroup(NewRG.name)
  params: {
    cdnProfileName: cdnProfileName
    endPointName: endPointName
    endPointNameStage: endPointNameStage
  }
}
