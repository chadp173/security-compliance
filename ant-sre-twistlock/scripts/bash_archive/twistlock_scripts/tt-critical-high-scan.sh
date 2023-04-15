#!/usr/bin/env bash
set -x

########################################
# IBM CIO Network Engineering:
# AnT Twistlock AAAaaS; ECN; BF
# Chad Perry <Chad.Perry1@us.ibm.com>
# This tool will:
#   Install IBM Cloud
#   Scan Images using Twistlock
#   Push to ant-sre-twistlock-reports
########################################

GARBAGE_COLLECTOR="metadata"
OVERVIEW="overview"
RESULTS="results"
CRITICAL="C"
HIGH="H"
BF="bf"
AAA="aaa"
ECN="ecn"



timestamp=$(date +"%Y%m%d%T")
chmod +x $PWD/files/tt_v1.4.0/linux_x86_64/tt
export GH_HOST=github.ibm.com

login_icr() {
  curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
  ibmcloud login -u ${W3ID} --apikey ${ICR_API_KEY} -r us-south
}

check_dependencies() {
  ./files/tt_v1.4.0/linux_x86_64/tt check-dependencies
}

##################
# BlueFringe ALL #
##################
bf_hc_critical() {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-hc-${BF_IMAGE}-${CRITICAL}.csv
  done
}

bf_vul_critical() {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-vul-${BF_IMAGE}-${CRITICAL}.csv
  done
}

bf_hc_high() {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-hc-${BF_IMAGE}-${HIGH}.csv
  done
}

bf_vul_high() {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-vul-${BF_IMAGE}-${HIGH}.csv
  done
}

###################
## AAA ALL Images #
###################
aaa_hc_critical() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacas aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-hc-${AAA_IMAGE}-${CRITICAL}.cvs
  done
}

aaa_vul_critical() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-vul-${AAA_IMAGE}-${CRITICAL}.cvs
  done
}

aaa_hc_high() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacas aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-hc-${AAA_IMAGE}-${HIGH}.cvs
  done
}

aaa_vul_high() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-vul-${AAA_IMAGE}-${HIGH}.cvs
  done
}

#######################
# Edge Compute Nodes  #
#######################

ecn_hc_critical() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of edge-hc-${EDGE_IMAGE}-${CRITICAL}.cvs
  done
}

ecn_vul_critical() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of edge-vul-${EDGE_IMAGE}-${CRITICAL}.cvs
  done
}

ecn_hc_high() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of edge-hc-${EDGE_IMAGE}-${HIGH}.cvs
  done
}

ecn_vul_high() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of edge-vul-${EDGE_IMAGE}-${HIGH}.cvs
  done
}

##########################
# Clone twistlock-reports
###########################
clone_reports() {
  cd /home/travis/build/
  git clone git@github.ibm.com:NetEngTools/ant-sre-twistlock-reports.git
  cd /home/travis/build/ant-sre-twistlock-reports
  git config user.email ${W3ID}
  git config user.name ${GITHUB_USER}
}

########################
# Remove Metadata
########################
remove_waste() {
for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
do
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-vul-${BF_IMAGE}-${CRITICAL}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-hc-${BF_IMAGE}-${CRITICAL}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-vul-${BF_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-hc-${BF_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
done


for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacas aaa-ui contrast-service sigsci-agent;
do
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-vul-${AAA_IMAGE}-${CRITICAL}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-vul-${AAA_IMAGE}-${CRITICAL}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-vul-${AAA_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-hc-${AAA_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
  # done


for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
do
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-vul-${EDGE_IMAGE}-${CRITICAL}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-hc--${EDGE_IMAGE}-${CRITICAL}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-vul-${EDGE_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-hc-${EDGE_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
done
}

preparing_github() {
for PROJ in bf ecn aaa;
do
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${PROJ}/vul/${timestamp}
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${PROJ}/hc/${timestamp}
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/HIGH/${PROJ}/vul/${timestamp}
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/HIGH/${PROJ}/hc/${timestamp}
done

##########################
# Orangnize Directories
###########################
move_folders(){
for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
do
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-vul-${BF_IMAGE}-${RESULTS}-${CRITICAL}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${BF}/vul/${timestamp}
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-hc-${BF_IMAGE}-${OVERVIEW}-${CRITICAL}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${BF}/hc/${timestamp}
done

for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
do
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-vul-${BF_IMAGE}-${RESULTS}-${HIGH}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${BF}/vul/${timestamp}
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-hc-${BF_IMAGE}-${OVERVIEW}-${HIGH}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${BF}/hc/${timestamp}
done

for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
do
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-vul-${EDGE_IMAGE}-${RESULTS}-${CRITICAL}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${ECN}/vul/${timestamp}
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-hc-${EDGE_IMAGE}-${OVERVIEW}-${CRITICAL}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${ECN}/hc/${timestamp}
done

for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
do
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-vul-${EDGE_IMAGE}-${RESULTS}-${HIGH}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${ECN}/vul/${timestamp}
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-hc-${EDGE_IMAGE}-${OVERVIEW}-${HIGH}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${ECN}/hc/${timestamp}
done

for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacas aaa-ui contrast-service sigsci-agent;
do
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-hc-${AAA_IMAGE}-${RESULTS}-${CRITICAL}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${AAA}/hc/${timestamp}
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-vul-${AAA_IMAGE}-${OVERVIEW}-${CRITICAL}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${AAA}/hc/${timestamp}
done

 for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacas aaa-ui contrast-service sigsci-agent;
 do
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-hc-${AAA_IMAGE}-${RESULTS}-${HIGH}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${AAA}/hc/${timestamp}
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-vul-${AAA_IMAGE}-${OVERVIEW}-${HIGH}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${AAA}/hc/${timestamp}
 done
}

#############################
# Add files to GitHub
############################
add_files() {
git checkout -b Twistlock-${TRAVIS_BUILD_NUMBER}

for PROJ in bf ecn aaa;
do
  git add /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${PROJ}/vul/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${PROJ}/hc/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/HIGH/${PROJ}/vul/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/HIGH/${PROJ}/hc/${timestamp}
done
}

git_push() {
git commit --message "Travis Build ${TRAVIS_BUILD_NUMBER}"
git push "git@github.ibm.com:NetEngTools/ant-sre-twistlock-reports.git" Twistlock-${TRAVIS_BUILD_NUMBER} >/dev/null 2>&1
}

# Setting up TT
login_icr
check_dependencies

# Health Checks
bf_hc_critical
aaa_hc_critical
ecn_hc_critical
bf_hc_high
aaa_hc_high
ecn_hc_high

# Vulnerabilities
bf_vul_critical
aaa_vul_critical
ecn_vul_critical
bf_vul_high
aaa_vul_high
ecn_vul_high

#GitHub
clone_reports
remove_waste
preparing_github
move_folders
add_files
git_push
