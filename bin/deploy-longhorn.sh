#!/bin/bash

PARENT_PATH=$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)
BASE_PATH=$PARENT_PATH/../

export KUBECONFIG=${BASE_PATH}k3s.yaml

# install longhorn
helm repo add longhorn https://charts.longhorn.io
helm repo update

helm upgrade --install longhorn longhorn/longhorn \
    --namespace longhorn-system \
    --create-namespace \
    -f ${BASE_PATH}/addons/longhorn/values.yaml

kubectl apply -f ${BASE_PATH}/addons/longhorn/ingress.yaml
