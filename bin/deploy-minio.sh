#!/bin/bash

# https://github.com/bitnami/charts/tree/master/bitnami/minio/#installing-the-chart

PARENT_PATH=$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)
BASE_PATH=$PARENT_PATH/../

export KUBECONFIG=${BASE_PATH}k3s.yaml


helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install minio bitnami/minio\
    --namespace minio \
    --create-namespace \
    -f ${BASE_PATH}/addons/minio/values.yaml
