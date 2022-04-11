#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m'    # No Color

echo "############################################################################"
echo "Now deploying microk8s on multipass VMs"
echo "############################################################################"

echo -e "[${LB}Info${NC}] deploy microk8s on k8s-master"
MASTERS=$(echo $(multipass list | grep master | awk '{print $1}'))
WORKERS=$(echo $(multipass list | grep worker | awk '{print $1}'))
NODES="${MASTERS} ${WORKERS}"

echo -e "[${LB}Info${NC}] deploy microk8s on all nodes (including master)"
for NODE in ${NODES}; do
    echo ${node}
    multipass exec ${NODE} -- sudo snap install microk8s --classic
    multipass exec ${NODE} -- sudo usermod -a -G microk8s ubuntu
    multipass exec ${NODE} -- sudo chown -f -R ubuntu ~/.kube

    # You may need to configure your firewall to allow pod-to-pod and pod-to-internet communication
    multipass exec ${NODE} -- sudo ufw allow in on cni0 && sudo ufw allow out on cni0
    multipass exec ${NODE} -- sudo ufw default allow routed
    multipass exec ${NODE} -- sudo iptables -P FORWARD ACCEPT

    # longhorn dependencies
    multipass exec ${NODE} -- sudo apt-get update
    multipass exec ${NODE} -- sudo apt-get install -y open-iscsi nfs-common jq
    multipass exec ${NODE} -- sudo systemctl enable --now iscsid
    multipass exec ${NODE} -- sudo systemctl is-active --quiet iscsid.service && echo 'iscsid is running'

    multipass exec ${NODE} -- sudo snap alias microk8s.kubectl kubectl
done

echo "############################################################################"
echo exporting KUBECONFIG file from master node
multipass exec k8s-master -- microk8s config >~/.kube/config
multipass exec k8s-master -- microk8s config >k3s.yaml
multipass exec k8s-master -- microk8s status --wait-ready
export KUBECONFIG=$(pwd)/k3s.yaml && echo -e "[${LB}Info${NC}] setting KUBECONFIG=${KUBECONFIG}"

# kubectl config rename-context default k8s-multipass
# https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
# echo -e "[${LB}Info${NC}] tainting master node: k8s-master"
# kubectl taint node k8s-master node-role.kubernetes.io/master=effect:NoSchedule
echo -e "[${LB}Info${NC}] joining all workers"
echo ${WORKERS}
for WORKER in ${WORKERS}; do
    echo -e "[${LB}Info${NC}] deploy microk8s on ${WORKER}"
    JOIN_COMMAND=$(multipass exec k8s-master -- microk8s add-node | head -n 2 | tail -1)
    multipass exec ${WORKER} -- $JOIN_COMMAND --worker
done
echo "############################################################################"
echo -e "[${GREEN}All nodes have joined the cluster ${NC}]"
echo "############################################################################"


READY_COMMAND=$(kubectl get nodes | grep 'NotReady' | wc -l)
NB=1
while [ $READY_COMMAND -gt 0 ]; do
    echo "waiting for nodes to be ready... ${NB}x"
    READY_COMMAND=$(kubectl get nodes | grep 'NotReady' | wc -l)
    NB=$((NB+1))
    sleep 10
done
echo "############################################################################"
echo -e "[${GREEN}All nodes are ready ${NC}]"
echo "############################################################################"

for WORKER in ${WORKERS}; do
    kubectl label node ${WORKER} node-role.kubernetes.io/node= >/dev/null && echo -e "[${LB}Info${NC}] label ${WORKER} with node"
done

sleep 10
multipass exec k8s-master -- microk8s enable storage dns # metrics-server prometheus

# config map and secret reloader
kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml

kubectl get nodes

echo "are the nodes ready?"
echo "if you face problems, please open an issue on github"

echo "############################################################################"
echo -e "[${GREEN}Success microk8s deployment rolled out${NC}]"
echo "############################################################################"
