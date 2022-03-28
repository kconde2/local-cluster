#!/bin/bash

PARENT_PATH=$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)
BASE_PATH=$PARENT_PATH/../

export KUBECONFIG=${BASE_PATH}k3s.yaml

helm upgrade --install redis bitnami/redis \
    --namespace redis \
    --create-namespace \
    -f ${BASE_PATH}/addons/redis/values.yaml
