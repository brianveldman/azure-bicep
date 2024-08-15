@secure()
param kubeConfig string

extension kubernetes with {
  kubeConfig: kubeConfig
  namespace: 'default'
}

var frontName = 'nginx-website'
var frontPort = 80

@description('Application front-end deployment (NGINX)')
resource frontDeploy 'apps/Deployment@v1' = {
  metadata: {
    name: frontName
  }
  spec: {
    replicas: 1
    selector: {
      matchLabels: {
        app: frontName
      }
    }
    template: {
      metadata: {
        labels: {
          app: frontName
        }
      }
      spec: {
        containers: [
          {
            name: frontName
            image: 'nginx:latest'
            resources: {
              requests: {
                cpu: '100m'
                memory: '128Mi'
              }
              limits: {
                cpu: '250m'
                memory: '256Mi'
              }
            }
            ports: [
              {
                containerPort: frontPort
              }
            ]
          }
        ]
      }
    }
  }
}

@description('Configure front-end service')
resource frontSvc 'core/Service@v1' = {
  metadata: {
    name: frontName
  }
  spec: {
    type: 'LoadBalancer'
    ports: [
      {
        port: frontPort
      }
    ]
    selector: {
      app: frontName
    }
  }
}
