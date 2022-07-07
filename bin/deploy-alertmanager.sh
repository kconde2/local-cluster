#!/bin/bash

URL="\`alertmanager.2d9baa17.nip.io\`"

# Crée un Secret contenant plusieurs clés
cat <<EOF | kubectl apply -f -
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: alertmanager
  namespace: monitoring
spec:
  entryPoints:
    - web
  routes:
  - kind: Rule
    match: Host($URL) && PathPrefix(\`/\`)
    services:
    - name: alertmanager-main
      port: 9093
EOF
