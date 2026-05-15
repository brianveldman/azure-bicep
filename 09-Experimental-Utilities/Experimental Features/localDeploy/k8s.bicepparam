using 'k8s.bicep'

param kubeConfig = base64(loadTextContent('./secrets/kubeconfig.yml'))
