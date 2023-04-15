#!/usr/bin/env bash
set -x

########################################
# IBM CIO Network Engineering:
# AnT Twistlock AAAaaS
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

####################
## AAA ALL Images ##
####################
aaa_hc() {
    for AAA_IMAGE in aaa-api aaa-controller aaa-radius aaa-tacas aaa-ui contrast-service siasci-agent;
    do
      ./tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006480 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C  us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-hc-${AAA_IMAGE}.csv
    done
}

aaa_vul(){
  for AAA_IMAGE in aaa-api aaa-controller aaa-radius aaa-tacas aaa-ui contrast-service siasci-agent;
  do
    ./tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006480 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V  us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-vul-${AAA_IMAGE}.csv;
  done
}

file_compression() {
mkdir -p local-reports/aaa/${time_stamp}
mkdir -p local-reports/aaa/${time_stamp}/vulnerabilities
mkdir -p local-reports/aaa/${time_stamp}/compliance
rm -rf *.metadata.csv
rm -rf *.overview.csv
mv aaa-hc-* /local-reports/aaa/${time_stamp}//compliance
mv  aaa-vul-* /local-reports/aaa/${time_stamp}/vulnerabilities
tar -zcvf /tmp/$W3ID.tgz /local-reports/aaa/${time_stamp}/
}

# TT Setup
login_icr
check_dependencies

# Health Checks
aaa_hc

# Vulnerabilities
aaa_vul

# file compression
file_compression
