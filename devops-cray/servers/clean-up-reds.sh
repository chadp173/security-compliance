#!/bin/bash
set -x
set -e
NCN='api-gw-service-nmn.local'
curl -X DELETE -k https://$NCN/apis/smd/hsm/v1/Inventory/RedfishEndpoints
curl -X DELETE -k https://$NCN/apis/smd/hsm/v1/State/Components
curl -X DELETE -k https://$NCN/apis/smd/hsm/v1/Defaults/NodeMaps
kubectl delete -f /root/k8s/cray_reds.yaml || true
while [ -n "$(kubectl get pods | grep reds)" ]; do sleep 1; done
curl -f -k -i -X DELETE https://$NCN/apis/datastore/keys/river-endpoint-discovery/switch-state
curl -f -k -i -X DELETE https://$NCN/apis/datastore/keys/river-endpoint-discovery/mac-state
curl -f -k -i -X DELETE https://$NCN/apis/datastore/keys/river-endpoint-discovery/creds-state
curl -f -k -i -X DELETE https://$NCN/apis/datastore/keys/river-endpoint-discovery/mapping
kubectl create -f /root/k8s/cray_reds.yaml
while [ -z "$(kubectl get pods | grep reds | grep Running)" ] ; do sleep 1; done
curl -f -k --basic --user root:initial0 -v -d '@/opt/cray/crayctl/ansible_framework/roles/reds-bootstrap/files/cray_reds_mapping.json' -i -X PUT https://$NCN/apis/reds/v1/admin/port_xname_map
curl -k -d '@/opt/cray/crayctl/ansible_framework/roles/reds-bootstrap/files/preview_node_nid_map.json' -X POST https://$NCN/apis/smd/hsm/v1/Defaults/NodeMaps

kubectl delete configmap cray-bss-ipxe-conf  --ignore-not-found=true
kubectl create configmap cray-bss-ipxe-conf --from-file=/root/k8s/bss_ipxe.conf
podname=$(kubectl get pods | grep cray-dhcp | awk '{ print $1 }')
kubectl delete pod "$podname"
podname=$(kubectl get pods | grep cray-bss | awk '{ print $1 }')
kubectl delete pod "$podname"
echo "OK"
echo "Reboot all nodes."
