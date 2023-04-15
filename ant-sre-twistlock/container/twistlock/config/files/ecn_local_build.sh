#!/usr/bin/env bash
set -x

# Variables
time_stamp=$(date +"%Y%m%d%T")

twistlock_check() {
  ./tt_v1.4.0/linux_x86_64/tt check-dependencies
}

login_icr() {
  ibmcloud login -u ${W3ID} --apikey ${ICR_API_KEY} -r us-south
  ibmcloud update -f
}

#######################
# Edge Compute Nodes  #
#######################
ecn_hc() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
    ./tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of ecn-hc-${EDGE_IMAGE}.cvs;
  done
}

ecn_vul() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
   ./tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of ecn-vul-${EDGE_IMAGE}.cvs;
  done
}

file_compression() {
mkdir -p local-reports/edge-compute/${time_stamp}
mkdir -p local-reports/edge-compute/${time_stamp}/vulnerabilities
mkdir -p local-reports/edge-compute/${time_stamp}/compliance
rm -rf *.metadata.csv
rm -rf *.overview.csv
mv ecn-hc-* /local-reports/edge-compute/${time_stamp}/compliance
mv ecn-vul-* /local-reports/edge-compute/${time_stamp}/vulnerabilities
tar -zcvf /tmp/$W3ID.tgz /local-reports/edge-compute/${time_stamp}
}

# TT Functions
twistlock_check
login_icr

# Edge Health Checks
ecn_hc

# Edge Vulnerabilities
ecn_vul

# file compression
file_compression
