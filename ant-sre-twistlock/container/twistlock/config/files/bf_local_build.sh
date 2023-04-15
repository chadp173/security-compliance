#!/usr/bin/env bash
set -x

########################################
# IBM CIO Network Engineering:
# AnT Twistlock Bluefringe
# Chad Perry <Chad.Perry1@us.ibm.com>
# This tool will:
#   Install IBM Cloud
#   Scan Images using Twistlock Container
#   Create a Tar file in /tmp
########################################

# Variables
time_stamp=$(date +"%Y%m%d")

twistlock_check() {
./tt_v1.4.0/linux_x86_64/tt check-dependencies
}

login_icr() {
  ibmcloud login -u ${W3ID} --apikey ${ICR_API_KEY} -r us-south
  ibmcloud update -f
}

bf_vul() {
  for BF_IMAGE in fringe_de_att_diag edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./tt_v1.4.0/linux_x86_64/tt  images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-vul-$BF_IMAGE.csv
  done
}

bf_hc() {
  for BF_IMAGE in fringe_de_att_diag edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-hc-$BF_IMAGE.csv;
  done;
}

file_compression() {
mkdir -p local-reports/bf-gold/${time_stamp}
mkdir -p local-reports/bf-gold/${time_stamp}/vulnerabilities
mkdir -p local-reports/bf-gold/${time_stamp}/compliance
rm -rf *.metadata.csv
rm -rf *.overview.csv
mv bf-vul-* /local-reports/bf-gold/${time_stamp}/vulnerabilities
mv bf-hc-* /local-reports/bf-gold/${time_stamp}/compliance
tar -zcvf /tmp/$W3ID.tgz /local-reports/bf-gold/${time_stamp}
}

# TT Setup Functions
twistlock_check
login_icr

# BF Health Checks
bf_hc

# BF Vulnerabilities
bf_vul


# Compression
file_compression
