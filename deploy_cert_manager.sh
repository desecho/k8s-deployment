#!/bin/bash

set -eu

if [ -z $DEPLOY_CERT_MANAGER ]; then
    exit 0
fi

kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --set installCRDs=true
kubectl apply -f cert-manager/production-issuer.yaml
