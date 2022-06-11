#!/bin/bash

set -eou pipefail

function wait_for_readiness() {
    echo "Waiting for readiness..."
    local retries=0
    while [ "${retries}" -lt 15 ]; do
        local ip
        ip="$(kubectl get service/nginx-ingress-ingress-nginx-controller -n ingress-nginx -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')"
        if [[ -n "$ip" ]]; then
            echo "IP - $ip"
            break
        else
            echo "Retrying..."
            retries=$((retries + 1))
            sleep 30
        fi
    done

    if [ -z "${ip}" ]; then
        echo "Timeout"
        return 1
    fi
}

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create namespace ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --set controller.publishService.enabled=true

# Configure MySQL support
kubectl apply -f nginx-ingress/ingress-nginx-configmap.yaml
filename="$(mktemp)"
kubectl get deployments/nginx-ingress-ingress-nginx-controller -n ingress-nginx -o yaml > "$filename"
# shellcheck disable=SC2016
sed 's/- \/nginx-ingress-controller/- \/nginx-ingress-controller\n        - --tcp-services-configmap=$(POD_NAMESPACE)\/tcp-services/g' "$filename" -i
kubectl apply -f "$filename"

patch="$(cat nginx-ingress/patches/deployment-nginx-ingress-ingress-nginx-controller-patch.yaml)"
kubectl patch deployment nginx-ingress-ingress-nginx-controller -n ingress-nginx --patch "$patch"

patch="$(cat nginx-ingress/patches/service-nginx-ingress-ingress-nginx-controller-patch.yaml)"
kubectl patch service nginx-ingress-ingress-nginx-controller -n ingress-nginx --patch "$patch"
wait_for_readiness
