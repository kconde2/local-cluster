#!/usr/bin/env bash

multipass launch --cpus 4 --mem 4096M --name single-node --disk 10G 20.04

multipass exec single-node -- sudo iptables -P FORWARD ACCEPT

multipass exec single-node -- sudo snap install microk8s --classic
multipass exec single-node -- sudo usermod -a -G microk8s ubuntu
multipass exec single-node -- sudo chown -f -R ubuntu ~/.kube

# export kubeconfig to manage cluster externally
multipass exec single-node -- microk8s config > ~/.kube/multipass-single-node
multipass exec single-node -- microk8s status --wait-ready

# config map and secret reloader
kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml

multipass exec single-node -- microk8s kubectl cluster-info

# multipass exec single-node -- sudo ufw allow in on cni0 && sudo ufw allow out on cni0
# multipass exec single-node -- sudo ufw default allow routed
# multipass exec single-node -- microk8s kubectl config view --raw
multipass exec single-node -- microk8s enable storage dashboard dns

./traefik/traefik.sh

# echo "$IP k8s.com traefik.k8s.com" > /etc/hosts
