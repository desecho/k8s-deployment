# Kubernetes deployment

Deployments for:
- nginx-ingress with MySQL support
- MySQL
- Let's Encrypt cert-manager

These GitHub secret variables have to be set for deployment:
- `KUBECONFIG_DATA`

For cert-manager deployment you need to set this variable:
- `EMAIL`

For MySQL deployment you need to set this variable:
- `MYSQL_ROOT_PASSWORD`
