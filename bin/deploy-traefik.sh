#!/bin/bash

PARENT_PATH=$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)
BASE_PATH=$PARENT_PATH/../
export KUBECONFIG=${BASE_PATH}k3s.yaml

helm repo add traefik https://helm.traefik.io/traefik

kubectl create ns dev
kubectl create ns uat
kubectl create ns prod

IP=$(multipass info k8s-master | grep IPv4 | awk '{print $2}')

helm upgrade --install traefik \
    --namespace traefik \
    --create-namespace \
    --set "service.externalIPs={$IP}" \
    traefik/traefik \
    -f ${BASE_PATH}/addons/traefik/traefik.values.yaml

kubectl apply -f ${BASE_PATH}/addons/traefik/traefik.dashboard.yaml
