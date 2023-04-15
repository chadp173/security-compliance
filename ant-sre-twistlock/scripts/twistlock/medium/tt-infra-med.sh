#!/usr/bin/env bash
set -x

################################################
# IBM CIO Network Engineering:
# AnT Twistlock AAAaaS; ECN; INFRA; Infrasture
# Chad Perry <Chad.Perry1@us.ibm.com>
# This tool will:
#   Install IBM Cloud
#   Scan Images using Twistlock
#   Push to ant-sre-twistlock-reports
#   Create GitHub Issue
##################################################

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
# 	Infra Scan   #
##################

jenk_sec_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/bluefringe/${SECONDARY}:${SECONDARY_TAG} -of ${INFRA}-hc-${SECONDARY}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/bluefringe/${SECONDARY}:${SECONDARY_TAG} -of ${INFRA}-vul-${SECONDARY}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/bluefringe/${SECONDARY}:${SECONDARY_TAG} -of ${INFRA}-vul-${SECONDARY}-${LOW}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/bluefringe/${SECONDARY}:${SECONDARY_TAG} -of ${INFRA}-hc-${SECONDARY}-${LOW}.csv
}

jenk_agent_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/bluefringe/${AGENT}:${AGENT_TAG} -of ${INFRA}-hc-${AGENT}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/bluefringe/${AGENT}:${AGENT_TAG} -of ${INFRA}-vul-${AGENT}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/bluefringe/${AGENT}:${AGENT_TAG} -of ${INFRA}-hc-${AGENT}-${LOW}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/bluefringe/${AGENT}:${AGENT_TAG}  -of ${INFRA}-vul-${AGENT}-${LOW}.csv
}

jenk_prim_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/bluefringe/${PRIMARY}:${PRIMARY_TAG} -of ${INFRA}-hc-${PRIMARY}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/bluefringe/${PRIMARY}:${PRIMARY_TAG} -of ${INFRA}-vul-${PRIMARY}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/bluefringe/${PRIMARY}:${PRIMARY_TAG} -of ${INFRA}-hc-${PRIMARY}-${LOW}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/bluefringe/${PRIMARY}:${PRIMARY_TAG} -of ${INFRA}-vul-${PRIMARY}-${LOW}.csv
}

grafana_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/bluefringe/${GRAFANA}:${GRAFANA_TAG} -of ${INFRA}-hc-${GRAFANA}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/bluefringe/${GRAFANA}:${GRAFANA_TAG} -of ${INFRA}-vul-${GRAFANA}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/bluefringe/${GRAFANA}:${GRAFANA_TAG} -of ${INFRA}-hc-${GRAFANA}-${LOW}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/bluefringe/${GRAFANA}:${GRAFANA_TAG} -of ${INFRA}-vul-${GRAFANA}-${LOW}.csv
}

netim_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/bluefringe/${NETIM}:${NETIM_TAG} -of ${INFRA}-vul-${NETIM}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/bluefringe/${NETIM}:${NETIM_TAG} -of ${INFRA}-hc-${NETIM}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/bluefringe/${NETIM}:${NETIM_TAG} -of ${INFRA}-hc-${NETIM}-${LOW}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/bluefringe/${NETIM}:${NETIM_TAG} -of ${INFRA}-vul-${NETIM}-${LOW}.csv
}

sysdig_agent_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/bluefringe/${SYSDIG}/${SY_AGENT_TAG} -of ${INFRA}-hc-${SYSDIG}-agent-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/bluefringe/${SYSDIG}/${SY_AGENT_TAG} -of ${INFRA}-vul-${SYSDIG}-agent-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/bluefringe/${SYSDIG}/${SY_AGENT_TAG} -of ${INFRA}-hc-${SYSDIG}-agent-${LOW}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/bluefringe/${SYSDIG}/${SY_AGENT_TAG} -of ${INFRA}-vul-${SYSDIG}-agent-${LOW}.csv
}

sysdig_python_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/bluefringe/python3-${SYSDIG}:${PY_TAG} -of ${INFRA}-hc-python3-${SYSDIG}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/bluefringe/python3-${SYSDIG}:${PY_TAG} -of ${INFRA}-vul-python3-${SYSDIG}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/bluefringe/python3-${SYSDIG}:${PY_TAG} -of ${INFRA}-hc-python3-${SYSDIG}-${LOW}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/bluefringe/python3-${SYSDIG}:${PY_TAG} -of ${INFRA}-vul-python3-${SYSDIG}-${LOW}.csv
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

###############
# Prep GitHub #
###############

preparing_github() {
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/vul/${timestamp}
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/hc/${timestamp}
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/vul/${timestamp}
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/hc/${timestamp}
}

###############
# Move Files  #
###############

jenk_sec_results(){
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${SECONDARY}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${SECONDARY}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${SECONDARY}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${SECONDARY}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/vul/${timestamp}
}

jenk_agent_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${AGENT}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${AGENT}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${AGENT}-${MEDIUM}.${RESULTS}.csv  /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${AGENT}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/vul/${timestamp}
}

jenk_prim_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${PRIMARY}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${PRIMARY}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${PRIMARY}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${PRIMARY}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/vul/${timestamp}
}

grafana_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${GRAFANA}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${GRAFANA}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${GRAFANA}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${GRAFANA}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/vul/${timestamp}
}

netim_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${NETIM}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${NETIM}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${NETIM}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${NETIM}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/vul/${timestamp}
}

sysdig_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${SYSDIG}-agent-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${SYSDIG}-agent-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${SYSDIG}-agent-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${SYSDIG}-agent-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/vul/${timestamp}
}

sysdig_python3_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-python3-${SYSDIG}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-python3-${SYSDIG}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-python3-${SYSDIG}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-python3-${SYSDIG}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/vul/${timestamp}
}


merge_files() {
cd /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${INFRA}-hc-${MEDIUM}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${INFRA}-vul-${MEDIUM}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${INFRA}-hc-${LOW}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${INFRA}-vul-${LOW}.${RESULTS}.csv
}

#############################
# Add files to GitHub
############################

add_files() {
git checkout -b Twistlock-${TRAVIS_JOB_NUMBER}
  git add /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/vul/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${INFRA}/hc/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/vul/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/LOW/${INFRA}/hc/${timestamp}
}

git_push() {
git commit --message "Travis Build ${TRAVIS_JOB_NUMBER}"
git push "git@github.ibm.com:NetEngTools/ant-sre-twistlock-reports.git" Twistlock-${TRAVIS_JOB_NUMBER} >/dev/null 2>&1
}


#########################
# Create GitHub Issue
##########################

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
gh issue create --title "Twistlock ${INFRA_MEDIUM} Build: ${TRAVIS_JOB_NUMBER}" --body "GitHub PR: https://github.ibm.com/NetEngTools/ant-sre-twistlock-reports/compare/Twistlock-${TRAVIS_JOB_NUMBER}?expand=1"
}

# Setting up TT
login_icr
check_dependencies

# Jenkins
jenk_sec_scan
jenk_agent_scan
jenk_prim_scan

# NetIM
grafana_scan
netim_scan

# sysdig
sysdig_agent_scan
sysdig_python_scan

# GitHub
clone_reports

# Preparing GH
preparing_github

# Move Files
jenk_sec_results
jenk_agent_results
jenk_prim_results
grafana_results
netim_results
sysdig_results
sysdig_python3_results
merge_files

# GH Commit & Push
add_files
git_push

# Create GitHub Issue
install_gh_cli
gh_auth
create_issues
