#!/usr/bin/env bash
set -x

################################################
# IBM CIO Network Engineering:
# AnT Twistlock POLARHUBaaS; ECN; BF; Polar Hub
# Chad Perry <Chad.Perry1@us.ibm.com>
# This tool will:
#   Install IBM Cloud
#   Scan Images using Twistlock
#   Push to ant-sre-twistlock-reports
#   Create GitHub Issue
################################################

source $PWD/scripts/twistlock/tl-variables.env

########################################################

timestamp=$(date +"%Y%m%d%T")
chmod +x $PWD/files/tt_v1.4.0/linux_x86_64/tt
export GH_HOST=github.ibm.com

########################################################

login_icr() {
  curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
  ibmcloud login -u ${W3ID} --apikey ${ICR_API_KEY} -r us-south
}

check_dependencies() {
  ./files/tt_v1.4.0/linux_x86_64/tt check-dependencies
}

########################
## POLARHUB ALL Images #
########################

polarhub_hc_critical() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/ant-polarhub-dev/${NETBOX_BASE}:${BASE_TAG} -of polarhub-hc-${NETBOX_BASE}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/ant-polarhub-dev/${CISCO_NSO}:${CISCO_TAG} -of polarhub-hc-${CISCO_NSO}-${CRITICAL}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter C us.icr.io/ant-polarhub-dev/${DUO_PROXY}:${DUO_PROXY_TAG} -of polarhub-hc-${DUO_PROXY}-${CRITICAL}.csv
}

polarhub_vul_critical() {
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/ant-polarhub-dev/${NETBOX_BASE}:${BASE_TAG} -of polarhub-vul-${NETBOX_BASE}-${CRITICAL}.csv
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/ant-polarhub-dev/${CISCO_NSO}:${CISCO_TAG} -of polarhub-vul-${CISCO_NSO}-${CRITICAL}.csv
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter C us.icr.io/ant-polarhub-dev/${DUO_PROXY}:${DUO_PROXY_TAG} -of polarhub-vul-${DUO_PROXY}-${CRITICAL}.csv
}

polarhub_hc_high() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/ant-polarhub-dev/${NETBOX_BASE}:${BASE_TAG} -of polarhub-hc-${NETBOX_BASE}-${HIGH}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/ant-polarhub-dev/${CISCO_NSO}:${CISCO_TAG} -of polarhub-hc-${CISCO_NSO}-${HIGH}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter H us.icr.io/ant-polarhub-dev/${DUO_PROXY}:${DUO_PROXY_TAG} -of polarhub-hc-${DUO_PROXY}-${HIGH}.csv

}

polarhub_vul_high() {
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/ant-polarhub-dev/${NETBOX_BASE}:${BASE_TAG} -of polarhub-vul-${NETBOX_BASE}-${HIGH}.csv
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/ant-polarhub-dev/${CISCO_NSO}:${CISCO_TAG} -of polarhub-vul-${CISCO_NSO}-${HIGH}.csv
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter H us.icr.io/ant-polarhub-dev/${DUO_PROXY}:${DUO_PROXY_TAG} -of polarhub-vul-${DUO_PROXY}-${HIGH}.csv
}


############################
# Clone twistlock-reports  #
############################

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
mkdir -p /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${POLARHUB}/vul/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/HIGH/${POLARHUB}/vul/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${POLARHUB}/hc/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/HIGH/${POLARHUB}/hc/${timestamp}
}

##########################
# Orangnize Directories
###########################

move_folders() {
for POLARHUB_IMAGE in ${NETBOX_BASE} ${CISCO_NSO} ${DUO_PROXY};
do
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${POLARHUB}-hc-${POLARHUB_IMAGE}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${POLARHUB}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${POLARHUB}-vul-${POLARHUB_IMAGE}-${CRITICAL}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${POLARHUB}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${POLARHUB}-hc-${POLARHUB_IMAGE}-${HIGH}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/HIGH/${POLARHUB}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${POLARHUB}-vul-${POLARHUB_IMAGE}-${HIGH}.${RESULTS}.csv  /home/travis/build/ant-sre-twistlock-reports/HIGH/${POLARHUB}/vul/${timestamp}
done
}

##########################
# Create single CSV      #
##########################

merge_files() {
cd /home/travis/build/ant-sre-twistlock-reports/HIGH/${POLARHUB}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${POLARHUB}-vul-${HIGH}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/HIGH/${POLARHUB}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${POLARHUB}-hc-${HIGH}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${POLARHUB}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${POLARHUB}-hc-${CRITICAL}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${POLARHUB}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${POLARHUB}-vul-${CRITICAL}.${RESULTS}.csv
}

#############################
# Add files to GitHub       #
#############################

add_files() {
git checkout -b Twistlock-${TRAVIS_JOB_NUMBER}
git add /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${POLARHUB}/vul/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/HIGH/${POLARHUB}/vul/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/CRITICAL/${POLARHUB}/hc/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/HIGH/${POLARHUB}/hc/${timestamp}
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
# GITHUB_API_TOKEN - saved as a hash value with travis encrypt
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
gh issue create --title "Twistlock ${POLARHUB_CRITICAL} Build: ${TRAVIS_JOB_NUMBER}" --body "GitHub PR: https://github.ibm.com/NetEngTools/ant-sre-twistlock-reports/compare/Twistlock-${TRAVIS_JOB_NUMBER}?expand=1"
}

# Setting up TT
login_icr
check_dependencies

# Health Checks
polarhub_hc_critical
polarhub_hc_high

# Vulnerabilities
polarhub_vul_critical
polarhub_vul_high

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
