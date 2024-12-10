@minLength(5)
@maxLength(50)
@description('Base name for all resources')
param baseName string = 'vbellens2024'

@description('Location for all resources')
param location string = resourceGroup().location

@description('Container image name')
param containerRegistryImageName string = 'myapp'

@description('Container image version/tag')
param containerRegistryImageVersion string = 'latest'

// Deploy Azure Container Registry
module acr 'modules/acr.bicep' = {
  name: 'acrDeploy'
  params: {
    name: replace(toLower('${baseName}acr'), '-', '')
    location: location
  }
}

// Deploy App Service Plan
module appServicePlan 'modules/appServicePlan.bicep' = {
  name: 'appServicePlanDeploy'
  params: {
    name: '${baseName}-asp'
    location: location
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
    }
    kind: 'Linux'
    reserved: true
  }
}

// Deploy Web App
module webApp 'modules/webApp.bicep' = {
  name: 'webAppDeploy'
  params: {
    name: '${baseName}-webapp'
    location: location
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acr.outputs.loginServer}/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: 'false'
      DOCKER_REGISTRY_SERVER_URL: 'https://${acr.outputs.loginServer}'
    }
    acrName: acr.outputs.registryName
  }
}
