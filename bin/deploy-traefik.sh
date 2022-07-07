#!/bin/bash

PARENT_PATH=$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)
BASE_PATH=$PARENT_PATH/../
VALUES_FILE=traefik.online.values.yaml
DASHBOARD_CONFIG=traefik.online.dashboard.yaml

# Here we avoid giving to traefik static IP adress and use metallb instead
# to allow dynamic IP allocation to all services.
# Make sure to have metallb deployed with at least one IP adress.

# IPS=45.155.170.23
export KUBECONFIG=${BASE_PATH}k3s.yaml

helm repo add traefik https://helm.traefik.io/traefik

#IP=$(multipass info k8s-master | grep IPv4 | awk '{print $2}')

helm upgrade --install traefik \
    --namespace traefik \
    --create-namespace \
    traefik/traefik \
    -f "${BASE_PATH}"/addons/traefik/${VALUES_FILE}

kubectl apply -f "${BASE_PATH}"/addons/traefik/${DASHBOARD_CONFIG}
