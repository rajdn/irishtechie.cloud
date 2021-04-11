param location string
param cdnProfileName string

resource cdnProfile 'Microsoft.Cdn/profiles@2020-04-15' = {
  location: location
  name: cdnProfileName
  sku: {
    name: 'Standard_Microsoft'
  }
}
