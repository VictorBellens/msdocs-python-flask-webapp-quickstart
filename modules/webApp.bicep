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

@description('Name of the Azure Container Registry')
param acrName string

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  kind: kind
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: serverFarmResourceId
    siteConfig: siteConfig
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrName
}

resource acrPullRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, webApp.id, 'acrPull')
  scope: acr
  properties: {
    principalId: webApp.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalType: 'ServicePrincipal'
  }
}

resource webAppSettings 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: webApp
  name: 'appsettings'
  properties: appSettingsKeyValuePairs
}

output name string = webApp.name
