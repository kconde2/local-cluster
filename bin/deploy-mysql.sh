#!/bin/bash

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
BASE_PATH=$PARENT_PATH/../
# MYSQL_HELM_PATH=${BASE_PATH}/addons/mysql-operator

# # installing mysql operator
# helm upgrade --install mysql-operator $MYSQL_HELM_PATH/helm/mysql-operator \
#     --namespace 'mysql-operator' \
#     --create-namespace

# # mysql innodbcluster
# helm upgrade --install mycluster $MYSQL_HELM_PATH/helm/mysql-innodbcluster \
#     --namespace 'mysql-innodbcluster' \
#     --create-namespace \
#     --set credentials.root.user='root' \
#     --set credentials.root.password='supersecret' \
#     --set credentials.root.host='%' \
#     --set serverInstances=3 \
#     --set routerInstances=3

# Deploying MOCO (https://cybozu-go.github.io/moco/setup.html)
curl -fsL https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.yaml | kubectl apply -f -
curl -fsL https://github.com/cybozu-go/moco/releases/latest/download/moco.yaml | kubectl apply -f -
kubectl krew update
kubectl krew install moco

kubectl apply -f ${BASE_PATH}/addons/moco/cluster.yaml


# helm upgrade --install my-release-mariadb stable/mariadb -f values-production.yaml --set rootUser.password=ROOT_PASSWORD --set replication.password=REPLICATION_PASSWORD
