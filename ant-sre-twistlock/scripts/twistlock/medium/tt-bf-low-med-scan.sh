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
#   Create GitHub Issue
########################################

source $PWD/scripts/twistlock/tl-variables.env
##################################################
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
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/bluefringe/${BF_IMAGE}:${BF_TAG} -of bf-hc-${BF_IMAGE}-${MEDIUM}.csv
  done
}

bf_vul_medium() {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/bluefringe/${BF_IMAGE}:${BF_TAG} -of bf-vul-${BF_IMAGE}-${MEDIUM}.csv
  done
}

bf_hc_low() {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/bluefringe/${BF_IMAGE}:${BF_TAG} -of bf-hc-${BF_IMAGE}-${LOW}.csv
  done
}

bf_vul_low() {
  for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/bluefringe/${BF_IMAGE}:${BF_TAG} -of bf-vul-${BF_IMAGE}-${LOW}.csv
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
# GitHub
########################

preparing_github() {

mkdir -p /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${BF}/vul/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${BF}/hc/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/LOW/${BF}/hc/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/LOW/${BF}/vul/${timestamp}
}

##########################
# Orangnize Directories
###########################

move_folders() {
for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
do
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-vul-${BF_IMAGE}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${BF}/vul/${timestamp}
   mv /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-hc-${BF_IMAGE}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${BF}/hc/${timestamp}
done

 for BF_IMAGE in edge_svc keystone ciocssp_web core-deploy-tools fringe_analytics_svc fringe_de_att120 fringe_de_expand fringe_de_fromsl fringe_de_ipassign fringe_de_policy_approve fringe_de_policy_check fringe_rdb fringe_svc;
 do
    mv /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-vul-${BF_IMAGE}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${BF}/vul/${timestamp}
    mv /home/travis/build/NetEngTools/ant-sre-twistlock/${BF}-hc-${BF_IMAGE}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${BF}/hc/${timestamp}
 done
}

##########################
# Create single CSV
##########################

merge_files() {
cd /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${BF}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${AAA}-vul-${MEDIUM}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${BF}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${BF}-hc-${MEDIUM}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/LOW/${BF}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${BF}-hc-${LOW}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/LOW/${BF}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${BF}-vul-${LOW}.${RESULTS}.csv
}

#############################
# Add files to GitHub
############################
add_files() {
git checkout -b Twistlock-${TRAVIS_JOB_NUMBER}
git add /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${BF}/vul/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${BF}/hc/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/LOW/${BF}/vul/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/LOW/${BF}/hc/${timestamp}
}

git_push() {
git commit --message "Travis Build ${TRAVIS_JOB_NUMBER}"
git push "git@github.ibm.com:NetEngTools/ant-sre-twistlock-reports.git" Twistlock-${TRAVIS_JOB_NUMBER} >/dev/null 2>&1
}

#############################
# Create Github Issue
#############################
install_gh_cli() {
sudo apt update
sudo apt install snapd
sudo snap install gh
}

gh_auth() {
export GH_HOST=github.ibm.com; echo ${GITHUB_API_TOKEN}  | gh auth login --hostname github.ibm.com --with-token
}

create_issues() {
git config user.email ${W3ID}
git config user.name ${GITHUB_USER}
export GH_REPO=NetEngTools/ant-sre-twistlock-reports
gh issue create --title "Twistlock Travis ${BF_MEDIUM}: ${TRAVIS_JOB_NUMBER}" --body "GitHub PR: https://github.ibm.com/NetEngTools/ant-sre-twistlock-reports/compare/Twistlock-${TRAVIS_JOB_NUMBER}?expand=1"
}
# Setting up TT
login_icr
check_dependencies

# Health Checks
bf_hc_medium
bf_hc_low

# Vulnerabilities
bf_vul_medium
bf_vul_low

#GitHub
clone_reports
preparing_github
move_folders
merge_files
add_files
git_push

# Create GitHub Issue
install_gh_cli
gh_auth
create_issues
