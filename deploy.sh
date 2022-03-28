#!/bin/bash

GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m'    # No Color

# PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
# BASE_PATH=$PARENT_PATH/../
# cd BASE_PATH

# get start timestamp
res1=$(date +%s)

# deploy things
./bin/deploy-multipass-vms.sh
./bin/deploy-microk8s.sh
# ./9-install-metal-lb.sh
# ./11-deploy-ingress-nginx.sh

# get end timestamp
res2=$(date +%s)

# calculate runtime
dt=$(echo "$res2 - $res1" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)

echo "############################################################################"
echo -e "${GREEN}FINISHED${NC}"
echo -e '
 _________
/\        \
\_| Enjoy |
  |       |
  |   ____|_
   \_/______/
'
printf "${GREEN}Total runtime in minutes was: %02d:%02.f\n${NC}" $dm $ds
echo "############################################################################"
