#!/usr/bin/env bash

# TODO: improve script with read -p
# https://github.com/arashkaffamanesh/bonsai/blob/master/1-deploy-multipass-vms.sh

workers=('worker1' 'worker2')
masters=('master')
nodes=("${masters[@]}" "${workers[@]}")


# Create nodes
for node in ${nodes[@]}; do
    # multipass launch --name "${node}" --cpus 1 --mem 2048M --disk 10G 20.04
    multipass launch --name "${node}" --disk 10G 20.04
done

multipass list

for node in ${nodes[@]}; do
    multipass exec ${node} -- sudo snap install microk8s --classic
    multipass exec ${node} -- sudo usermod -a -G microk8s ubuntu
    multipass exec ${node} -- sudo chown -f -R ubuntu ~/.kube
done

# export kubeconfig to manage cluster externally
multipass exec master -- /snap/bin/microk8s.config > ~/.kube/multipass-node3
multipass exec master -- microk8s status --wait-ready

#export KUBECONFIG=$(pwd)/kubeconfig

# configure other nodes
for worker in ${workers[@]}; do
    JOIN_COMMAND=$(multipass exec master -- microk8s add-node | head -n 2 | tail -1)
    multipass exec ${worker} -- $JOIN_COMMAND --worker
done

# config map and secret reloader
kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml

multipass exec master -- /snap/bin/microk8s.kubectl cluster-info
