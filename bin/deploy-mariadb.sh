#!/bin/bash

# https://github.com/bitnami/charts/tree/master/bitnami/mariadb

PARENT_PATH=$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)
BASE_PATH=$PARENT_PATH/../

export KUBECONFIG=${BASE_PATH}k3s.yaml

ROOT_PASSWORD=$(kubectl get secret --namespace mariadb-cluster mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)

helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install mariadb bitnami/mariadb \
    --namespace mariadb-cluster \
    --create-namespace \
    --set architecture=replication \
    --set global.storageClass=microk8s-hostpath \
    --set auth.rootPassword=root \
    --set volumePermissions.enabled=true \
    --set secondary.replicaCount=2 \
    --set auth.replicationPassword=root

# ** Please be patient while the chart is being deployed **

# Tip:

#   Watch the deployment status using the command: kubectl get pods -w --namespace mariadb-cluster -l app.kubernetes.io/instance=mariadb

# Services:

#   echo Primary: mariadb-primary.mariadb-cluster.svc.cluster.local:3306
#   echo Secondary: mariadb-secondary.mariadb-cluster.svc.cluster.local:3306

# Administrator credentials:

#   Username: root
#   Password : $(kubectl get secret --namespace mariadb-cluster mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)

# To connect to your database:

#   1. Run a pod that you can use as a client:

#       kubectl run mariadb-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mariadb:10.5.15-debian-10-r30 --namespace mariadb-cluster --command -- bash

#   2. To connect to primary service (read/write):

#       mysql -h mariadb-primary.mariadb-cluster.svc.cluster.local -uroot -p my_database

#   3. To connect to secondary service (read-only):

#       mysql -h mariadb-secondary.mariadb-cluster.svc.cluster.local -uroot -p my_database

# To upgrade this helm chart:

#   1. Obtain the password as described on the 'Administrator credentials' section and set the 'auth.rootPassword' parameter as shown below:

#       ROOT_PASSWORD=$(kubectl get secret --namespace mariadb-cluster mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
#       helm upgrade --namespace mariadb-cluster mariadb bitnami/mariadb --set auth.rootPassword=$ROOT_PASSWORD
