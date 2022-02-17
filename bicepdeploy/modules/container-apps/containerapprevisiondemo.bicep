param containerAppsEnvName string
param location string

resource cappsEnv 'Microsoft.Web/kubeEnvironments@2021-03-01' existing = {
  name: containerAppsEnvName
}

resource containerappsrevisiondemo 'Microsoft.Web/containerApps@2021-03-01' = {
  name: 'containerappsrevisiondemo'
  location: location
  properties: {
    kubeEnvironmentId: cappsEnv.id
    template: {
      containers: [
        {
          name: 'revisiondemo'
          image: 'gutheriecacr.azurecr.io/containerapprevisiondemo:v0.1'
        }
      ]
      scale: {
        minReplicas: 0
      }
      dapr: {
        enabled: false
      }
    }
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
    }
  }
}

output subdomain string = containerappsrevisiondemo.name
