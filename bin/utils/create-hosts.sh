#!/bin/bash

MASTER=$(echo $(multipass list | grep master | awk '{print $1}'))
WORKERS=$(echo $(multipass list | grep worker | awk '{print $1}'))
NODES+=$MASTER
NODES+=" "
NODES+=$WORKERS

echo "############################################################################"
echo "Creating hosts"
echo "############################################################################"

cp /etc/hosts hosts.backup
cp /etc/hosts hosts.local
sudo rm hosts.cleanup.backup

# make new hosts file for multipase vms
touch hosts.vm

FILES=('hosts.vm' 'hosts.local')
for f in "${FILES[@]}"; do
    # seach for existing multipass config
    exists=$(grep -n "####### multipass hosts start ##########" ${f} | awk -F: '{print $1}' | head -1)
    # check if var is empty
    if test -z "$exists"; then
        exists=0
    fi

    # cut existing config
    if (("$exists" > "0")); then
        start=$(grep -n "####### multipass hosts start ##########" ${f} | awk -F: '{print $1}' | head -1)
        ((start = start - 1))
        end=$(grep -n "####### multipass hosts end   ##########" ${f} | awk -F: '{print $1}' | head -1)
        sed -i '' ${start},${end}d ${f}
    fi

    # replace with new config
    echo "" >>${f}
    echo "####### multipass hosts start ##########" >>${f}

    for NODE in ${NODES}; do
        IP=$(multipass info ${NODE} | grep IPv4 | awk '{print $2}')
        echo "${IP} ${NODE}" >>${f}
    done

    echo "####### multipass hosts end   ##########" >>${f}
done

echo "We need to write the host entries on your local machine to /etc/hosts"
echo "Please provide your sudo password:"
sudo cp hosts.local /etc/hosts

echo "############################################################################"
echo "Writing multipass host entries to /etc/hosts on the VMs:"

for NODE in ${NODES}; do
    multipass transfer hosts.vm ${NODE}:
    multipass exec ${NODE} -- sudo iptables -P FORWARD ACCEPT
    multipass exec ${NODE} -- bash -c 'sudo chown ubuntu:ubuntu /etc/hosts'
    multipass exec ${NODE} -- bash -c 'sudo cat /home/ubuntu/hosts.vm >> /etc/hosts'
done

# cleanup tmp hostfiles
rm hosts.vm
