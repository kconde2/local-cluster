#!/bin/bash

## Adding the Official Grafana Helm Repo
helm repo add grafana https://grafana.github.io/helm-charts

## Update the helm chart
helm repo update

## Install helm chart with the following Stack enabled ( Loki, Promtail, Grafana, Prometheus )
helm upgrade --install loki --namespace=loki-stack grafana/loki-stack  \
    --set grafana.enabled=true \
    --set prometheus.enabled=true \
    --set prometheus.alertmanager.persistentVolume.enabled=false \
    --set prometheus.server.persistentVolume.enabled=false

URL="\`grafana.2d9baa17.nip.io\`"

# Crée un Secret contenant plusieurs clés
cat <<EOF | kubectl apply -f -
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: grafana
  namespace: default
spec:
  entryPoints:
    - web
  routes:
  - kind: Rule
    match: Host($URL) && PathPrefix(\`/\`)
    services:
    - name: loki-grafana
      port: 80
EOF
