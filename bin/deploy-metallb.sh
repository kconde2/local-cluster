#!/bin/bash

PARENT_PATH=$(
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)
BASE_PATH=$PARENT_PATH/../
export KUBECONFIG=${BASE_PATH}k3s.yaml

# TODO: manage this dynamically with NODES variables
IP1=$(multipass info k8s-master | grep IPv4 | awk '{print $2}')
IP2=$(multipass info k8s-worker1 | grep IPv4 | awk '{print $2}')
IP3=$(multipass info k8s-worker2 | grep IPv4 | awk '{print $2}')

multipass exec k8s-master -- microk8s enable metallb:${IP1}-${IP1},${IP2}-${IP2},${IP3}-${IP3}

# microk8s.enable metallb:$(curl ipinfo.io/ip)-$(curl ipinfo.io/ip)
