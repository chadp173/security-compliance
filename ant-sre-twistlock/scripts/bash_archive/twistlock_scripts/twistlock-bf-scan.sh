#!/usr/bin/env bash
set -x

######################################## 
# IBM CIO Network Engineering:
# AnT Twistlock Bluefringe
# Chad Perry <Chad.Perry1@us.ibm.com>
# This tool will:
#   Install IBM Cloud
#   Scan Images using Twistlock 
#   Push to ant-sre-twistlock-reports
########################################

timestamp=$(date +"%Y%m%d%T")
chmod +x $PWD/files/tt_v1.4.0/linux_x86_64/tt
export GH_HOST=github.ibm.com

login_icr() {
  curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
  ibmcloud login -u ${W3ID} --apikey ${ICR_API_KEY}  -r us-south
}
check_dependencies() {
  ./files/tt_v1.4.0/linux_x86_64/tt check-dependencies
}

##################
# BlueFringe ALL #
##################
bf_hc () {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-hc-${BF_IMAGE}.csv
  done
}

bf_vul () {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V us.icr.io/bluefringe/${BF_IMAGE}:GOLD -of bf-vul-scan-${BF_IMAGE}.csv
  done
}

clone_reports() {
  cd /home/travis/build/
  git clone git@github.ibm.com:NetEngTools/ant-sre-twistlock-reports.git
  cd /home/travis/build/ant-sre-twistlock-reports
  git config user.email ${W3ID}
  git config user.name ${GITHUB_USER}
}

preparing_github() {
for RECORD in bf;
  do
    mkdir -p /home/travis/build/ant-sre-twistlock-reports/${RECORD}/hc/${timestamp}
done

for REC in bf;
  do
    mkdir -p /home/travis/build/ant-sre-twistlock-reports/${REC}/vul/${timestamp}
done

mv /home/travis/build/NetEngTools/ant-sre-twistlock/bf-vul-* /home/travis/build/ant-sre-twistlock-reports/bf/vul/${timestamp}
mv /home/travis/build/NetEngTools/ant-sre-twistlock/bf-hc-* /home/travis/build/ant-sre-twistlock-reports/bf/hc/${timestamp}
}

add_files() {
git checkout -b Twistlock-${TRAVIS_BUILD_NUMBER}

for DIR in bf;
do
  git add /home/travis/build/ant-sre-twistlock-reports/${DIR}/hc/${timestamp}
done

for DIRA in bf;
do
  git add /home/travis/build/ant-sre-twistlock-reports/${DIRA}/vul/${timestamp}
done
}

git_push(){
git commit --message "Travis Build ${TRAVIS_BUILD_NUMBER}"
git push "git@github.ibm.com:NetEngTools/ant-sre-twistlock-reports.git" Twistlock-${TRAVIS_BUILD_NUMBER} > /dev/null 2>&1
}

# TT Setup
login_icr
check_dependencies

# Health Checks
bf_hc

# Vulnerabilities
bf_vul

#GitHub
clone_reports
preparing_github
add_files
git_push
