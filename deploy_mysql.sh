#!/bin/bash

set -eu

if [ -z $DEPLOY_MYSQL ]; then
    exit 0
fi

kubectl create secret generic mysql --from-literal=MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
kubectl apply -f mysql/mysql-volume.yaml
kubectl apply -f mysql/mysql-deployment.yaml
kubectl apply -f mysql/mysql-service.yaml
