#!/bin/bash

set -eou pipefail

function wait_for_readiness() {
    echo "Waiting for readiness..."
    local retries=0
    while [ "${retries}" -lt 10 ]; do
        local ready_replicas
        ready_replicas="$(kubectl get deployments/redis -o=jsonpath='{.status.readyReplicas}')"
        if [[ $ready_replicas == "1" ]]; then
            echo "Ready"
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

kubectl apply -f redis/redis-deployment.yaml
kubectl apply -f redis/redis-service.yaml
wait_for_readiness
