# Kubernetes deployment

Deployments for:

- nginx-ingress with MySQL support
- MySQL
- Redis
- Let's Encrypt cert-manager

These GitHub secret variables have to be set for deployment:

- `KUBECONFIG`

For cert-manager deployment you need to set this variable:

- `EMAIL`

For MySQL deployment you need to set this variable:

- `MYSQL_ROOT_PASSWORD`

## CI/CD

[GitHub Actions](https://github.com/features/actions) are used for CI/CD.

Deployment is done manually in the master branch.

The following GitHub Actions are used:

- [Checkout](https://github.com/marketplace/actions/checkout)
- [Kubectl tool installer](https://github.com/marketplace/actions/kubectl-tool-installer)
- [Helm tool installer](https://github.com/marketplace/actions/helm-tool-installer)
