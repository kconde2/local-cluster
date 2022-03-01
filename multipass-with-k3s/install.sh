#!/usr/bin/env bash

# Create nodes
for i in 'node1' 'node2' 'node3'; do multipass launch --name "${i}" --cpus 1 --mem 2048M --disk 10G 20.04; done

multipass exec node1 -- bash -c "curl -sfL https://get.k3s.io | sh -s - server --disable traefik --disable servicelb --disable local-storage"

TOKEN=$(multipass exec node1 sudo cat /var/lib/rancher/k3s/server/node-token)
IP=$(multipass info node1 | grep IPv4 | awk '{print $2}')

# configure other nodes
multipass exec node2 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$IP:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
multipass exec node3 -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$IP:6443\" K3S_TOKEN=\"$TOKEN\" sh -"

# export kubeconfig
multipass exec node1 sudo cat /etc/rancher/k3s/k3s.yaml > k3s-config.yaml
sed -i "s/127.0.0.1/$IP/" k3s-config.yaml
export KUBECONFIG=$(pwd)/k3s-config.yaml

# MetalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# Config map and secret reloader
kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml
