#!/bin/bash

set -eu

if [ -z $DEPLOY_NGINX_INGRESS ]; then
    exit 0
fi

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create namespace ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --set controller.publishService.enabled=true

# Configure MySQL support
file_=$(mktemp)
kubectl get deployments/nginx-ingress-ingress-nginx-controller -n ingress-nginx -o yaml > $file_
sed 's/- \/nginx-ingress-controller/- \/nginx-ingress-controller\n        - --tcp-services-configmap=$(POD_NAMESPACE)\/tcp-services/g' $file_ -i
kubectl apply -f $file_

kubectl patch deployment nginx-ingress-ingress-nginx-controller -n ingress-nginx --patch "$(cat nginx-ingress/patches/deployment-nginx-ingress-ingress-nginx-controller-patch.yaml)"
kubectl patch service nginx-ingress-ingress-nginx-controller -n ingress-nginx --patch "$(cat nginx-ingress/patches/service-nginx-ingress-ingress-nginx-controller-patch.yaml)"
