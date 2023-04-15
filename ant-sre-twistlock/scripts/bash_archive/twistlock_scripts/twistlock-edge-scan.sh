#!/usr/bin/env bash
set -x

######################################## 
# IBM CIO Network Engineering:
# AnT Twistlock ECN 
# Chad Perry <Chad.Perry1@us.ibm.com>
# This tool will:
#   Install IBM Cloud
#   Scan Images using Twistlock 
#   Push to ant-sre-twistlock-reports
########################################

timestamp=$(date +"%Y%m%d%T")
chmod +x $PWD/files/tt_v1.4.0/linux_x86_64/ttt
export GH_HOST=github.ibm.com

login_icr() {
  curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
  ibmcloud login -u ${W3ID} --apikey ${ICR_API_KEY}  -r us-south
}
check_dependencies() {
  ./files/tt_v1.4.0/linux_x86_64/tt  check-dependencies
}

#######################
# Edge Compute Nodes  #
#######################
ecn_hc() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of edge-hc-${EDGE_IMAGE}.cvs
  done
}

ecn_vul() {
  for EDGE_IMAGE in thousandeyes-enterprise-agent thousandeyes-host-security-agent edge-portal-keystone edge-portal-svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V us.icr.io/edge-compute/${EDGE_IMAGE}:latest -of edge-vul-scan-${EDGE_IMAGE}.cvs
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
for RECORD in ecn;
  do
    mkdir -p /home/travis/build/ant-sre-twistlock-reports/${RECORD}/hc/${timestamp}
done

for REC in ecn;
  do
    mkdir -p /home/travis/build/ant-sre-twistlock-reports/${REC}/vul/${timestamp}
done

mv /home/travis/build/NetEngTools/ant-sre-twistlock/edge-vul-*  /home/travis/build/ant-sre-twistlock-reports/ecn/vul/${timestamp}
mv /home/travis/build/NetEngTools/ant-sre-twistlock/edge-hc-* /home/travis/build/ant-sre-twistlock-reports/ecn/hc/${timestamp}
}

add_files() {
git checkout -b Twistlock-${TRAVIS_BUILD_NUMBER}

for DIR in ecn;
do
  git add /home/travis/build/ant-sre-twistlock-reports/${DIR}/hc/${timestamp}
done

for DIRA in ecn;
do
  git add /home/travis/build/ant-sre-twistlock-reports/${DIRA}/vul/${timestamp}
done
}

git_push(){
git commit --message "Travis Build ${TRAVIS_BUILD_NUMBER}"
git push "git@github.ibm.com:NetEngTools/ant-sre-twistlock-reports.git" Twistlock-${TRAVIS_BUILD_NUMBER} > /dev/null 2>&1
}

# Setting up TT
login_icr
check_dependencies

# Health Checks
ecn_hc
ecn_vul

#GitHub
clone_reports
preparing_github
add_files
git_push
