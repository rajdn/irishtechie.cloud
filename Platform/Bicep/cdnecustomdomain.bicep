// Set the parameters and default values, if required.
param cdnProfileName string
param endPointName string
param endPointNameStage string

// Add custom domain.
resource customDomainWWW 'Microsoft.Cdn/profiles/endpoints/customdomains@2020-09-01' = {
  name: '${cdnProfileName}/${endPointName}/www-irishtechie-cloud'
  properties: {
    hostName: 'www.irishtechie.cloud'
  }
}

// Add custom domain.
resource customDomain 'Microsoft.Cdn/profiles/endpoints/customdomains@2020-09-01' = {
  name: '${cdnProfileName}/${endPointName}/irishtechie-cloud'
  properties: {
    hostName: 'irishtechie.cloud'
  }
}

// Add custom domain.
resource customDomainStaging 'Microsoft.Cdn/profiles/endpoints/customdomains@2020-09-01' = {
  name: '${cdnProfileName}/${endPointNameStage}/staging-irishtechie-cloud'
  properties: {
    hostName: 'staging.irishtechie.cloud'
  }
}
