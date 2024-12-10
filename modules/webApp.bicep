@description('Name of the Web App')
param name string

@description('Location for the Web App')
param location string

@description('Kind of Web App')
param kind string

@description('Resource ID of the App Service Plan')
param serverFarmResourceId string

@description('Site configuration for the Web App')
param siteConfig object

@description('App settings for the Web App')
param appSettingsKeyValuePairs object

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  kind: kind
  properties: {
    serverFarmId: serverFarmResourceId
    siteConfig: siteConfig
  }
}

resource webAppSettings 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: webApp
  name: 'appsettings'
  properties: appSettingsKeyValuePairs
}

output name string = webApp.name
