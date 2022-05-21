# Kubernetes deployment

Deployments for:
- nginx-ingress with MySQL support
- MySQL
- Let's Encrypt cert-manager

These GitHub secret variables have to be set for deployment:
- `KUBECONFIG`

For cert-manager deployment you need to set this variable:
- `EMAIL`

For MySQL deployment you need to set this variable:
- `MYSQL_ROOT_PASSWORD`

## CI/CD

[GitHub Actions](https://github.com/features/actions) are used for CI/CD.

Deployment is manually done in master branch.

The following GitHub Actions are used:

* [Cancel Workflow Action](https://github.com/marketplace/actions/cancel-workflow-action)
* [Checkout](https://github.com/marketplace/actions/checkout)
* [Kubectl tool installer](https://github.com/marketplace/actions/kubectl-tool-installer)
* [Helm tool installer](https://github.com/marketplace/actions/helm-tool-installer)
