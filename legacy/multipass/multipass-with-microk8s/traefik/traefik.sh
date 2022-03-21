#!/bin/bash

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
#helm upgrade --install traefik traefik/traefik -n traefik --create-namespace -f traefik.values.yaml

kubectl create ns dev
kubectl create ns uat
kubectl create ns prod
kubectl apply -f traefik.dashboard.yaml

IP=$(multipass info single-node | grep IPv4 | awk '{print $2}')

helm upgrade --install traefik \
    --namespace traefik \
    --create-namespace \
    --set "service.externalIPs={$IP}" \
    traefik/traefik
