#!/usr/bin/env bash 
set -x 

echo "Checking to see whether any hosts are labeled and ready to run UAIs"
NODES=(`kubectl get node --show-labels -l uas | grep Ready | awk '{ print $1 }'`)
if [ "${#NODES[@]}" -eq 0 ]; then
    echo "No nodes in Ready state with the uas=True label"
    exit 1
else
    echo "UAIs are deployable to nodes: ${NODES[*]}"
fi
echo "... OK"

