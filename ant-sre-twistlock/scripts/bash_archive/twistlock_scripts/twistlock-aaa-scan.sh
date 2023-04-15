#!/usr/bin/env bash
set -x

######################################## 
# IBM CIO Network Engineering:
# AnT Twistlock AAAaaS
# Chad Perry <Chad.Perry1@us.ibm.com>
# This tool will:
#   Install IBM Cloud
#   Scan Images using Twistlock 
#   Push to ant-sre-txwistlock-reports
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

####################
## AAA ALL Images ##
####################
aaa_hc() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-hc-${AAA_IMAGE}.cvs
  done
}

aaa_vul() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g ant-tool -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V us.icr.io/aaa-as-a-service/${AAA_IMAGE}:prod-latest -of aaa-vul-scan-${AAA_IMAGE}.cvs
  done
}

clone_reports() {
cd /home/travis/build/
git clone git@github.ibm.com:NetEngTools/ant-sre-twistlock-reports.git
cd  /home/travis/build/ant-sre-twistlock-reports
git config user.email ${W3ID}
git config user.name ${GITHUB_USER}
}

preparing_github() {
for RECORD in aaa;
do
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/${RECORD}/hc/${timestamp}
done

for REC in aaa;
do
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/${REC}/vul/${timestamp}
done

mv /home/travis/build/NetEngTools/ant-sre-twistlock/aaa-vul-*  /home/travis/build/ant-sre-twistlock-reports/aaa/vul/${timestamp}
mv /home/travis/build/NetEngTools/ant-sre-twistlock/aaa-hc-* /home/travis/build/ant-sre-twistlock-reports/aaa/hc/${timestamp}
}

add_files() {
git checkout -b Twistlock-${TRAVIS_BUILD_NUMBER}

for DIR in aaa;
do
  git add /home/travis/build/ant-sre-twistlock-reports/${DIR}/hc/${timestamp}
done

for DIRA in aaa;
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
aaa_hc

# Vulnerabilities
aaa_vul

#GitHub
clone_reports
preparing_github
add_files
git_push
