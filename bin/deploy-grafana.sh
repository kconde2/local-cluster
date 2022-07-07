#!/bin/bash

URL="\`grafana.2d9baa17.nip.io\`"

# Crée un Secret contenant plusieurs clés
cat <<EOF | kubectl apply -f -
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: grafana
  namespace: monitoring
spec:
  entryPoints:
    - web
  routes:
  - kind: Rule
    match: Host($URL) && PathPrefix(\`/\`)
    services:
    - name: grafana
      port: 3000
EOF
