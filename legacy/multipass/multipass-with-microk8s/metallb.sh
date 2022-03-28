#!/usr/bin/env bash

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
    namespace: metallb-system
    name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 10.231.22.61-10.231.22.173
EOF
