targetScope = 'subscription'

param location string = deployment().location
param uniqueSeed string = '${subscription().subscriptionId}-${deployment().name}'
param resourceGroupName string = 'revisiondemo-${uniqueString(uniqueSeed)}'
param containerAppsEnvName string = resourceGroupName
param logAnalyticsWorkspaceName string = resourceGroupName
param appInsightsName string = resourceGroupName

module resourceGroupModule 'modules/resourcegroup-deploy.bicep' = {
  name: '${deployment().name}--resourceGroup'
  scope: subscription()
  params: {
    location: location
    resourceGroupName: resourceGroupName
  }
}

module containerAppsEnvModule 'modules/capps-env.bicep' = {
  name: '${deployment().name}--containerAppsEnv'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    resourceGroupModule
  ]
  params: {
    location: location
    containerAppsEnvName: containerAppsEnvName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    appInsightsName: appInsightsName
  }
}
