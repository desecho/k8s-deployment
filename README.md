# Kubernetes deployment

Deployments for:
- nginx-ingress with MySQL support
- MySQL
- Let's Encrypt cert-manager

These GitHub secret variables have to be set for deployment:
- `KUBECONFIG_DATA`

Depending on what you want to be deployed you need to set these variables:
- `DEPLOY_MYSQL`
- `DEPLOY_NGINX_INGRESS`
- `DEPLOY_CERT_MANAGER`

For MySQL deployment you need to set this variable:
- `MYSQL_ROOT_PASSWORD`
