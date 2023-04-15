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
OVER="overview"
RES="results"
MEDIUM="M"
LOW="L"
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
bf_hc_medium() {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-hc-${BF_IMAGE}-${MEDIUM}.csv
  done
}

bf_vul_medium() {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-vul-${BF_IMAGE}-${MEDIUM}.csv
  done
}

bf_hc_low() {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-hc-${BF_IMAGE}-${LOW}.csv
  done
}

bf_vul_low() {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-vul-${BF_IMAGE}-${LOW}.csv
  done
}

###################
## AAA ALL Images #
###################

aaa_hc_medium() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacas aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-hc-${AAA_IMAGE}-${MEDIUM}.cvs
  done
}

aaa_vul_medium() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-vul-${AAA_IMAGE}-${MEDIUM}.cvs
  done
}

aaa_hc_low() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacas aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-hc-${AAA_IMAGE}-${LOW}.cvs
  done
}

aaa_vul_low() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-vul-${AAA_IMAGE}-${LOW}.cvs
  done
}

#######################
# Edge Compute Nodes  #
#######################

ecn_hc_medium() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of edge-hc-${EDGE_IMAGE}-${MEDIUM}.cvs
  done
}

ecn_vul_medium() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of edge-vul-${EDGE_IMAGE}-${MEDIUM}.cvs
  done
}

ecn_hc_low() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of edge-hc-${EDGE_IMAGE}-${LOW}.cvs
  done
}

ecn_vul_low() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of edge-vul-${EDGE_IMAGE}-${LOW}.cvs
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
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-vul-${BF_IMAGE}-${CRIT}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-hc-${BF_IMAGE}-${CRIT}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-vul-${BF_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-hc-${BF_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
done

for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacas aaa-ui contrast-service sigsci-agent;
do
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-vul-${AAA_IMAGE}-${CRIT}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-hc-${AAA_IMAGE}-${CRIT}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-vul-${AAA_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-hc-${AAA_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
done

for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
do
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-${EDGE_IMAGE}-${CRIT}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-hc-${EDGE_IMAGE}-${CRIT}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-vul-${EDGE_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
  rm -rf /home/travis/build/NetEngTools/ant-sre-twistlock/${ECN}-hc-${EDGE_IMAGE}-${HIGH}-${GARBAGE_COLLECTOR}.csv
}

preparing_github() {
for PROJ in aaa bf ecn;
do
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${PROJ}/hc/${timestamp}
    mkdir -p /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${PROJ}/vul/${timestamp}
done

for SEVFD in aaa bf ecn;
do
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/LOW/${PROJB}/hc/${timestamp}
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/LOW/${PROJB}/vul/${timestamp}
done
}


move_folders(){
for PROJC in aaa bf ecn;
do
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${PROJC}-hc-${RES}-${MEDIUM}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${PROJC}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${PROJC}-vul-${RES}-${MEDIUM}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${PROJC}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${PROJC}-hc-${OVER}-${LOW}.csv/home/travis/build/ant-sre-twistlock-reports/LOW/${PROJC}/vul/${timestamp}
    mv /home/travis/build/NetEngTools/ant-sre-twistlock/${PROJC}-vul-${OVER}-${LOW}.csv/home/travis/build/ant-sre-twistlock-reports/LOW/${PROJC}/vul/${timestamp}
done
}


add_files() {
git checkout -b Twistlock-${TRAVIS_BUILD_NUMBER}

for PROJ in aaa bf ecn;
do
  git add /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${PROJ}/hc/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${PROJ}/vul/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/LOW/${PROJ}/hc/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/LOW/${PROJ}/vul/${timestamp}
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
bf_hc_medium
aaa_hc_medium
ecn_hc_medium
bf_hc_low
aaa_hc_low
ecn_hc_low

# Vulnerabilities
bf_vul_medium
aaa_vul_medium
ecn_vul_medium
bf_vul_low
aaa_vul_low
ecn_vul_low

#GitHub
clone_reports
remove_waste
preparing_github
move_folders
add_files
git_push
