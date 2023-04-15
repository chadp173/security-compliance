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


###################
## AAA ALL Images #
###################
aaa_hc_critical() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006480 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/aaa-as-a-service/${AAA_IMAGE}:${AAA_TAG} -of aaa-hc-${AAA_IMAGE}-${CRITICAL}.csv
  done
}

aaa_vul_critical() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006480 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/aaa-as-a-service/${AAA_IMAGE}:${AAA_TAG} -of aaa-vul-${AAA_IMAGE}-${CRITICAL}.csv
  done
}

aaa_hc_high() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006480 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/aaa-as-a-service/${AAA_IMAGE}:${AAA_TAG} -of aaa-hc-${AAA_IMAGE}-${HIGH}.csv
  done
}

aaa_vul_high() {
  for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
  do
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006480 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/aaa-as-a-service/${AAA_IMAGE}:${AAA_TAG} -of aaa-vul-${AAA_IMAGE}-${HIGH}.csv
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

preparing_github() {
mkdir -p /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${AAA}/vul/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/HIGH/${AAA}/vul/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${AAA}/hc/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/HIGH/${AAA}/hc/${timestamp}
}

##########################
# Orangnize Directories
###########################

move_folders() {
for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
do
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-hc-${AAA_IMAGE}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${AAA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-vul-${AAA_IMAGE}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${AAA}/vul/${timestamp}
done

for AAA_IMAGE in aaa-api aaa-controller aaa-db aaa-radius aaa-tacacs aaa-ui contrast-service sigsci-agent;
do
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-hc-${AAA_IMAGE}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${AAA}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${AAA}-vul-${AAA_IMAGE}-${HIGH}.${RESULTS}.csv  /home/travis/build/ant-sre-twistlock-reports/HIGH/${AAA}/vul/${timestamp}
done
}

##########################
# Create single CSV
##########################

merge_files() {
cd /home/travis/build/ant-sre-twistlock-reports/HIGH/${AAA}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${AAA}-vul-${HIGH}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/HIGH/${AAA}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${AAA}-hc-${HIGH}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${AAA}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${AAA}-hc-${CRITICAL}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${AAA}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${AAA}-hc-${CRITICAL}.${RESULTS}.csv
}

#############################
# Add files to GitHub
############################
add_files() {
git checkout -b Twistlock-${TRAVIS_JOB_NUMBER}
git add /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${AAA}/vul/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/HIGH/${AAA}/vul/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${AAA}/hc/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/HIGH/${AAA}/hc/${timestamp}
}

#############
# Git Push
#############

git_push() {
git commit --message "Travis Build ${TRAVIS_JOB_NUMBER}"
git push "git@github.ibm.com:NetEngTools/ant-sre-twistlock-reports.git" Twistlock-${TRAVIS_JOB_NUMBER} >/dev/null 2>&1
}

#######################
# Create GitHub Issue
#######################

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
gh issue create --title "Twistlock ${AAA_CRITICAL} Build: ${TRAVIS_JOB_NUMBER}" --body "GitHub PR: https://github.ibm.com/NetEngTools/ant-sre-twistlock-reports/compare/Twistlock-${TRAVIS_JOB_NUMBER}?expand=1"
}

# Setting up TT
login_icr
check_dependencies

# Health Checks
aaa_hc_critical
aaa_hc_high

# Vulnerabilities
aaa_vul_critical
aaa_vul_high

# GitHub PR
clone_reports
preparing_github
move_folders
merge_files
add_files
git_push

# GitHub Issue
install_gh_cli
gh_auth
create_issues
