param location string
param cdnProfileName string
param endPointName string
param storageAccountHostName string

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2020-04-15' = {
  location: location
  name: '${cdnProfileName}/${endPointName}'
  properties: {
    originHostHeader: storageAccountHostName
    optimizationType: 'GeneralWebDelivery'
    isHttpAllowed: false
    isHttpsAllowed: true
    queryStringCachingBehavior: 'IgnoreQueryString'
    contentTypesToCompress: [
      'text/plain'
      'text/html'
      'text/css'
      'application/x-javascript'
      'text/javascript'
    ]
    isCompressionEnabled: true
    origins: [
      {
        name: 'primary'
        properties: {
          hostName: storageAccountHostName

        }
      }
    ]
  }
}

resource customDomainWWW 'Microsoft.Cdn/profiles/endpoints/customdomains@2020-09-01' = {
  name: '${cdnProfileName}/${endPointName}/www-irishtechie-cloud'
  properties: {
    hostName: 'www.irishtechie.cloud'
  }
}

resource customDomainStaging 'Microsoft.Cdn/profiles/endpoints/customdomains@2020-09-01' = {
  name: '${cdnProfileName}/${endPointName}/staging-irishtechie-cloud'
  properties: {
    hostName: 'staging.irishtechie.cloud'
  }
}

// output hostName string = endpoint.properties.hostName
// output originHostHeader string = endpoint.properties.originHostHeader
