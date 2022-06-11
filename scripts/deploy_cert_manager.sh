#!/bin/bash

set -eou pipefail

function wait_for_readiness() {
    echo "Waiting for readiness..."
    local retries=0
    while [ "${retries}" -lt 10 ]; do
        local ready_replicas
        ready_replicas="$(kubectl get deployment.apps/cert-manager-webhook --namespace cert-manager  -o=jsonpath='{.status.readyReplicas}')"
        if [[ "$ready_replicas" == "1" ]]; then
            echo "Replica is ready"
            break
        else
            echo "Retrying..."
            retries=$((retries + 1))
            sleep 5
        fi
    done

    if [ -z "${ready_replicas}" ]; then
        echo "Timeout"
        return 1
    fi
}

# This function is needed because of this error which goes away after some time.
# Error from server (InternalError): error when creating "cert-manager/production-issuer.yaml": Internal error occurred:
# failed calling webhook "webhook.cert-manager.io": Post "https://cert-manager-webhook.cert-manager.svc:443/mutate?timeout=10s":
# x509: certificate signed by unknown authority (possibly because of "x509: ECDSA verification failure" while trying to verify
# candidate authority certificate "cert-manager-webhook-ca")
function createClusterIssuer() {
    echo "Creating Cluster Issuer..."
    local retries=0
    set +e
    while [ "${retries}" -lt 10 ]; do
        kubectl apply -f cert-manager/production-issuer.yaml 2>/dev/null
        local exit_code="$?"
        if [[ "$exit_code" == "0" ]]; then
            echo "Cluster issuer is ready."
            break
        else
            echo "Retrying..."
            retries=$((retries + 1))
            sleep 10
        fi
    done

    if [[ "$exit_code" != "0" ]]; then
        echo "Timeout."
    fi
}

kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --set installCRDs=true
sed "s/\[email\]/$EMAIL/g" cert-manager/production-issuer.yaml -i
wait_for_readiness
createClusterIssuer
