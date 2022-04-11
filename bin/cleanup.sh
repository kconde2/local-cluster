#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m'    # No Color

MASTER=$(echo $(multipass list | grep master | awk '{print $1}'))
WORKERS=$(echo $(multipass list | grep worker | awk '{print $1}'))
NODES+=$MASTER
NODES+=" "
NODES+=$WORKERS

cleanupAnsw="y"
read -p "Do you want to clean your /etc/hosts from multipass entries (y/n)? [default:y] promt with [ENTER]:" input
cleanupAnsw="${input:-$cleanupAnsw}"

if [ $cleanupAnsw == 'y' ]; then
    sudo hostctl remove multipass-vms
    sudo cp /etc/hosts hosts.cleanup.backup
fi

# Stop then delete nodes
for NODE in ${NODES}; do multipass stop ${NODE} && multipass delete ${NODE}; done
# Free discspace
multipass purge

rm hosts.backup k3s.yaml.back k3s.yaml get_helm.sh 2>/dev/null
echo -e "[${GREEN}FINISHED${NC}]"
echo "############################################################################"
