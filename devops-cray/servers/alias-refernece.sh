###  CSPS3 / master system aliases #####

alias bss-dumpstate="curl -k https://api-gw-service-nmn.local/apis/bss/boot/v1/dumpstate | json_pp"
alias bss-bootparam="curl -k https://api-gw-service-nmn.local/apis/bss/boot/v1/bootparameters | json_pp"
alias ars-artifacts="curl -s https://api-gw-service-nmn.local/apis/ars/artifacts | json_pp"
alias hsm-components="curl -k https://api-gw-service-nmn.local/apis/smd/hsm/v1/State/Components | json_pp"
alias hsm-nid-map="curl -k https://api-gw-service-nmn.local/apis/smd/hsm/v1/Defaults/NodeMaps | json_pp"
alias redfish-endpoints="curl -k https://api-gw-service-nmn.local/apis/smd/hsm/v1/Inventory/RedfishEndpoints | json_pp"
# alias follow-reds-log="kubectl logs --follow `kubectl get pods | grep reds | awk '{ printf $1 }'` -c cray-reds"
alias reds-nid-map="curl -k https://api-gw-service-nmn.local/apis/datastore/keys/river-endpoint-discovery/mapping | json_pp"
alias ipt="ipmitool -I lanplus -U root -P initial0 -H "
alias chkhsn="ssh nid001001-nmn /scratch/chkhsn1.sh"
alias chkslurm="ssh nid001001-nmn sinfo"
alias chklustre='echo snx11259 `pdsh ls -ld /snx11259/jmetzner | wc -l` '
