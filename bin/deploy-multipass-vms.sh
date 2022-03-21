#!/bin/bash

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# check if required applications and files are available
$PARENT_PATH/utils/dependency-check.sh

nodeCount=2
read -p "How many worker nodes do you want? (default:$nodeCount) promt with [ENTER]:" inputNode
nodeCount="${inputNode:-$nodeCount}"
cpuCount=2
read -p "How many cpus do you want per node? (default:$cpuCount) promt with [ENTER]:" inputCpu
cpuCount="${inputCpu:-$cpuCount}"
memCount=2
read -p "How many gigabyte memory do you want per node? (default:$memCount) promt with [ENTER]:" inputMem
memCount="${inputMem:-$memCount}"
diskCount=20
read -p "How many gigabyte diskspace do you want per node? (default:$diskCount) promt with [ENTER]:" inputDisk
diskCount="${inputDisk:-$diskCount}"

MASTER=$(echo "k8s-master ") && WORKER=$(eval 'echo k8s-worker{1..'"$nodeCount"'}')

NODES+=$MASTER
NODES+=$WORKER

# Create containers
for NODE in ${NODES}; do
multipass launch --name ${NODE} --cpus ${cpuCount} --mem ${memCount}G --disk ${diskCount}G;
done

# Wait a few seconds for nodes to be up
sleep 5

# create hosts files for multipass vms and cluster access with local environment
$PARENT_PATH/utils/create-hosts.sh
