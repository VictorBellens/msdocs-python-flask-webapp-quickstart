@description('Name of the App Service Plan')
param name string

@description('Location for the App Service Plan')
param location string

@description('SKU configuration for the App Service Plan')
param sku object

@description('Kind of App Service Plan')
param kind string

@description('Reserved flag for Linux')
param reserved bool

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  sku: sku
  kind: kind
  properties: {
    reserved: reserved
  }
}

output id string = appServicePlan.id
