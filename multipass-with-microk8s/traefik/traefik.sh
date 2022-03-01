#!/bin/bash

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik -n traefik --create-namespace -f traefik.values.yaml
# helm upgrade traefik traefik/traefik -n traefik --values traefik.values.yaml
# kind create cluster --config="kind.config.yaml" --image="kindest/node:v2"

kubectl create ns dev
kubectl create ns uat
kubectl create ns prod
kubectl apply -f traefik.dashboard.yaml
kubectl apply -f mysql.deployment.yaml
kubectl apply -f mysql.pv.yaml
kubectl apply -f mysql.service.yaml