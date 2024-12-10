@description('Name of the Azure Container Registry')
param name string

@description('Location for the Azure Container Registry')
param location string

@description('Enable admin user for the Azure Container Registry')
param acrAdminUserEnabled bool

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

output loginServer string = acr.properties.loginServer
output registryName string = acr.name
output adminUsername string = acrAdminUserEnabled ? acr.listCredentials().username : ''
output adminPassword string = acrAdminUserEnabled ? acr.listCredentials().passwords[0].value : ''
