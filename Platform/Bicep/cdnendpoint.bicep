// Set the parameters and default values, if required.
param location string
param cdnProfileName string
param endPointName string
param storageAccountHostName string

// Deploy a CDN Endpoint with Rules Engine config for HTTPS Enforcement.
resource endpoint 'Microsoft.Cdn/profiles/endpoints@2020-04-15' = {
  location: location
  name: '${cdnProfileName}/${endPointName}'
  properties: {
    originHostHeader: storageAccountHostName
    optimizationType: 'GeneralWebDelivery'
    isHttpAllowed: true
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
    deliveryPolicy: {
      rules: [
        {
          name: 'EnforceHTTPS'
          order: 1
          conditions: [
            {
              name: 'RequestScheme'
              parameters: {
                matchValues: [
                  'HTTP'
                ]
                operator: 'Equal'
                negateCondition: false
                '@odata.type': '#Microsoft.Azure.Cdn.Models.DeliveryRuleRequestSchemeConditionParameters'
              }
            }
          ]
          actions: [
            {
              name: 'UrlRedirect'
              parameters: {
                redirectType: 'Found'
                destinationProtocol: 'Https'
                '@odata.type': '#Microsoft.Azure.Cdn.Models.DeliveryRuleUrlRedirectActionParameters'
              }
            }
          ]
        }
      ]
    }
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

