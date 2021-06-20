#!/bin/bash

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik -n traefik --create-namespace -f traefik.values.yaml
# helm upgrade traefik traefik/traefik -n traefik --values traefik.values.yaml
