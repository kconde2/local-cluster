#!/bin/bash

URL="\`kibana.2d9baa17.nip.io\`"

# Crée un Secret contenant plusieurs clés
cat <<EOF | kubectl apply -f -
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: kibana-logging
  namespace: kube-system
spec:
  entryPoints:
    - web
  routes:
  - kind: Rule
    match: Host($URL) && PathPrefix(\`/\`)
    services:
    - name: kibana-logging
      port: 5601
EOF
