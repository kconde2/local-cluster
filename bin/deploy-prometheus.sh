#!/bin/bash

source ./bin/deploy-setting.sh

echo "$CLUSTER_IP"

# https://jonbc.medium.com/hacking-your-way-to-observability-part-1-cf4cd42fb4dc

git clone https://github.com/prometheus-operator/kube-prometheus.git

# Install kube prometheus stack (Prometheus | Grafana | AlertManager)
# Create the namespace and CRDs, and then wait for them to be availble before creating the remaining resources
kubectl create -f manifests/setup

# Wait until the "servicemonitors" CRD is created. The message "No resources found" means success in this context.
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done

kubectl create -f manifests/

# URL="\`prometheus.$CLUSTER_IP.nip.io\`"

# # Crée un Secret contenant plusieurs clés
# cat <<EOF | kubectl apply -f -
# apiVersion: traefik.containo.us/v1alpha1
# kind: IngressRoute
# metadata:
#   name: prometheus
#   namespace: monitoring
# spec:
#   entryPoints:
#     - web
#   routes:
#   - kind: Rule
#     match: Host($URL) && PathPrefix(\`/\`)
#     services:
#     - name: prometheus-operated
#       port: 9090
# EOF
