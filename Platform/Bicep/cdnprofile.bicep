// Set the parameters and default values, if required.
param location string
param cdnProfileName string

// Deploy a CDN Profile.
resource cdnProfile 'Microsoft.Cdn/profiles@2020-04-15' = {
  location: location
  name: cdnProfileName
  sku: {
    name: 'Standard_Microsoft'
  }
}
