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
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/bluefringe/${SECONDARY}:${SECONDARY_TAG} -of ${INFRA}-hc-${SECONDARY}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/bluefringe/${SECONDARY}:${SECONDARY_TAG} -of ${INFRA}-vul-${SECONDARY}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/bluefringe/${SECONDARY}:${SECONDARY_TAG}  -of ${INFRA}-vul-${SECONDARY}-${HIGH}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/bluefringe/${SECONDARY}:${SECONDARY_TAG} -of ${INFRA}-hc-${SECONDARY}-${HIGH}.csv
}

jenk_agent_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/bluefringe/${AGENT}:${AGENT_TAG} -of ${INFRA}-hc-${AGENT}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/bluefringe/${AGENT}:${AGENT_TAG} -of ${INFRA}-vul-${AGENT}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/bluefringe/${AGENT}:${AGENT_TAG} -of ${INFRA}-hc-${AGENT}-${HIGH}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/bluefringe/${AGENT}:${AGENT_TAG} -of ${INFRA}-vul-${AGENT}-${HIGH}.csv
}

jenk_prim_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/bluefringe/${PRIMARY}:${PRIMARY_TAG} -of ${INFRA}-hc-${PRIMARY}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/bluefringe/${PRIMARY}:${PRIMARY_TAG} -of ${INFRA}-vul-${PRIMARY}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/bluefringe/${PRIMARY}:${PRIMARY_TAG} -of ${INFRA}-hc-${PRIMARY}-${HIGH}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/bluefringe/${PRIMARY}:${PRIMARY_TAG} -of ${INFRA}-vul-${PRIMARY}-${HIGH}.csv
}

grafana_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/bluefringe/${GRAFANA}:${GRAFANA_TAG} -of ${INFRA}-hc-${GRAFANA}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/bluefringe/${GRAFANA}:${GRAFANA_TAG} -of ${INFRA}-vul-${GRAFANA}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/bluefringe/${GRAFANA}:${GRAFANA_TAG} -of ${INFRA}-hc-${GRAFANA}-${HIGH}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/bluefringe/${GRAFANA}:${GRAFANA_TAG} -of ${INFRA}-vul-${GRAFANA}-${HIGH}.csv
}

netim_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/bluefringe/${NETIM}:${NETIM_TAG} -of ${INFRA}-vul-${NETIM}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/bluefringe/${NETIM}:${NETIM_TAG} -of ${INFRA}-hc-${NETIM}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/bluefringe/${NETIM}:${NETIM_TAG} -of ${INFRA}-hc-${NETIM}-${HIGH}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/bluefringe/${NETIM}:${NETIM_TAG} -of ${INFRA}-vul-${NETIM}-${HIGH}.csv
}

sysdig_agent_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/bluefringe/${SYSDIG}/${SY_AGENT_TAG} -of ${INFRA}-hc-${SYSDIG}-agent-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/bluefringe/${SYSDIG}/${SY_AGENT_TAG} -of ${INFRA}-vul-${SYSDIG}-agent-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/bluefringe/${SYSDIG}/${SY_AGENT_TAG} -of ${INFRA}-hc-${SYSDIG}-agent-${HIGH}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/bluefringe/${SYSDIG}/${SY_AGENT_TAG} -of ${INFRA}-vul-${SYSDIG}-agent-${HIGH}.csv
}

sysdig_python_scan() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/bluefringe/python3-${SYSDIG}:${PY_TAG} -of ${INFRA}-hc-python3-${SYSDIG}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/bluefringe/python3-${SYSDIG}:${PY_TAG} -of ${INFRA}-vul-python3-${SYSDIG}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/bluefringe/python3-${SYSDIG}:${PY_TAG} -of ${INFRA}-hc-python3-${SYSDIG}-${HIGH}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/bluefringe/python3-${SYSDIG}:${PY_TAG} -of ${INFRA}-vul-python3-${SYSDIG}-${HIGH}.csv
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
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/vul/${timestamp}
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/hc/${timestamp}
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/vul/${timestamp}
  mkdir -p /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/hc/${timestamp}
}

###############
# Move Files  #
###############

jenk_sec_results(){
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${SECONDARY}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${SECONDARY}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${SECONDARY}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${SECONDARY}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/vul/${timestamp}
}

jenk_agent_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${AGENT}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${AGENT}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${AGENT}-${CRITICAL}.${RESULTS}.csv  /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${AGENT}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/vul/${timestamp}
}

jenk_prim_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${PRIMARY}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${PRIMARY}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${PRIMARY}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${PRIMARY}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/vul/${timestamp}
}

grafana_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${GRAFANA}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${GRAFANA}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${GRAFANA}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${GRAFANA}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/vul/${timestamp}
}

netim_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${NETIM}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${NETIM}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${NETIM}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${NETIM}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/vul/${timestamp}
}

sysdig_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${SYSDIG}-agent-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${SYSDIG}-agent-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-${SYSDIG}-agent-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-${SYSDIG}-agent-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/vul/${timestamp}
}

sysdig_python3_results() {
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-python3-${SYSDIG}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-python3-${SYSDIG}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-hc-python3-${SYSDIG}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${INFRA}-vul-python3-${SYSDIG}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/vul/${timestamp}
}


merge_files() {
cd /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${INFRA}-hc-${CRITICAL}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${INFRA}-vul-${CRITICAL}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${INFRA}-hc-${HIGH}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${INFRA}-vul-${HIGH}.${RESULTS}.csv
}

#############################
# Add files to GitHub
############################

add_files() {
git checkout -b Twistlock-${TRAVIS_JOB_NUMBER}
  git add /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/vul/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${INFRA}/hc/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/vul/${timestamp}
  git add /home/travis/build/ant-sre-twistlock-reports/HIGH/${INFRA}/hc/${timestamp}
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
gh issue create --title "Twistlock ${INFRA_CRITICAL} Build: ${TRAVIS_JOB_NUMBER}" --body "GitHub PR: https://github.ibm.com/NetEngTools/ant-sre-twistlock-reports/compare/Twistlock-${TRAVIS_JOB_NUMBER}?expand=1"
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
