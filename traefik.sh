#!/bin/bash

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik -n traefik --create-namespace -f traefik.values.yaml
# helm upgrade traefik traefik/traefik -n traefik --values traefik.values.yaml

kubectl create ns uat
kubectl create ns prod
kubectl apply -f traefik.dashboard.yaml
kubectl apply -f mysql.deployment.yaml
kubectl apply -f mysql.pv.yaml
kubectl apply -f mysql.service.yaml
kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml
