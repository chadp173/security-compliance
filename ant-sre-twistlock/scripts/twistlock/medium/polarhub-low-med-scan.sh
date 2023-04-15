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

login_icr() {
  curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
  ibmcloud login -u ${W3ID} --apikey ${ICR_API_KEY} -r us-south
}

check_dependencies() {
  ./files/tt_v1.4.0/linux_x86_64/tt check-dependencies
}

polarhub_hc_medium() {
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/ant-polarhub-dev/${NETBOX_BASE}:${BASE_TAG} -of polarhub-hc-${NETBOX_BASE}-${MEDIUM}.csv

./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/ant-polarhub-dev/${CISCO_NSO}:${CISCO_TAG} -of polarhub-hc-${CISCO_NSO}-${MEDIUM}.csv
./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter M us.icr.io/ant-polarhub-dev/${DUO_PROXY}:${DUO_PROXY_TAG} -of polarhub-hc-${DUO_PROXY}-${MEDIUM}.csv

}

polarhub_vul_medium() {
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/ant-polarhub-dev/${NETBOX_BASE}:${BASE_TAG} -of polarhub-vul-${NETBOX_BASE}-${MEDIUM}.csv
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/ant-polarhub-dev/${CISCO_NSO}:${CISCO_TAG} -of polarhub-vul-${CISCO_NSO}-${MEDIUM}.csv
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403 -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter M us.icr.io/ant-polarhub-dev/${DUO_PROXY}:${DUO_PROXY_TAG} -of polarhub-vul-${DUO_PROXY}-${MEDIUM}.csv
}

polarhub_hc_low() {
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/ant-polarhub-dev/${NETBOX_BASE}:${BASE_TAG} -of polarhub-hc-${NETBOX_BASE}-${LOW}.csv
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/ant-polarhub-dev/${CISCO_NSO}:${CISCO_TAG} -of polarhub-hc-${CISCO_NSO}-${LOW}.csv
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter C --severity-filter L us.icr.io/ant-polarhub-dev/${DUO_PROXY}:${DUO_PROXY_TAG} -of polarhub-hc-${DUO_PROXY}-${LOW}.csv
}

polarhub_vul_low() {
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/ant-polarhub-dev/${NETBOX_BASE}:${BASE_TAG} -of polarhub-vul-${NETBOX_BASE}-${LOW}.csv
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/ant-polarhub-dev/${CISCO_NSO}:${CISCO_TAG} -of polarhub-vul-${CISCO_NSO}-${LOW}.csv
    ./files/tt_v1.4.0/linux_x86_64/tt images pull-and-scan -u ${W3ID}:${TWISTLOCK_API} -g eal_eal-006403  -ik ${ICR_API_KEY} -q --has-fix-filter Y --issue-type-filter V --severity-filter L us.icr.io/ant-polarhub-dev/${DUO_PROXY}:${DUO_PROXY_TAG} -of polarhub-vul-${DUO_PROXY}-${LOW}.csv
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
mkdir -p /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${POLARHUB}/vul/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/LOW/${POLARHUB}/vul/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${POLARHUB}/hc/${timestamp}
mkdir -p /home/travis/build/ant-sre-twistlock-reports/LOW/${POLARHUB}/hc/${timestamp}
}

##########################
# Orangnize Directories
###########################

move_folders() {
for POLARHUB_IMAGE in ${NETBOX_BASE} ${CISCO_NSO} ${DUO_PROXY};
do
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${POLARHUB}-hc-${POLARHUB_IMAGE}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${POLARHUB}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${POLARHUB}-vul-${POLARHUB_IMAGE}-${MEDIUM}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${POLARHUB}/vul/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${POLARHUB}-hc-${POLARHUB_IMAGE}-${LOW}.${RESULTS}.csv /home/travis/build/ant-sre-twistlock-reports/LOW/${POLARHUB}/hc/${timestamp}
  mv /home/travis/build/NetEngTools/ant-sre-twistlock/${POLARHUB}-vul-${POLARHUB_IMAGE}-${LOW}.${RESULTS}.csv  /home/travis/build/ant-sre-twistlock-reports/LOW/${POLARHUB}/vul/${timestamp}
done
}

##########################
# Create single CSV      #
##########################

merge_files() {
cd /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${POLARHUB}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${POLARHUB}-vul-${MEDIUM}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${POLARHUB}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${POLARHUB}-hc-${MEDIUM}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/LOW/${POLARHUB}/hc/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${POLARHUB}-hc-${LOW}.${RESULTS}.csv

cd /home/travis/build/ant-sre-twistlock-reports/LOW/${POLARHUB}/vul/${timestamp}
awk 'FNR==1 && NR!=1{next;}{print}' *.csv > ${MASTER}-${POLARHUB}-vul-${LOW}.${RESULTS}.csv
}

#############################
# Add files to GitHub       #
#############################

add_files() {
git checkout -b Twistlock-${TRAVIS_JOB_NUMBER}
git add /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${POLARHUB}/vul/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/LOW/${POLARHUB}/vul/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/MEDIUM/${POLARHUB}/hc/${timestamp}
git add /home/travis/build/ant-sre-twistlock-reports/LOW/${POLARHUB}/hc/${timestamp}
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
gh issue create --title "Twistlock ${POLAR_MEDIUM} Build: ${TRAVIS_JOB_NUMBER}" --body "GitHub PR: https://github.ibm.com/NetEngTools/ant-sre-twistlock-reports/compare/Twistlock-${TRAVIS_JOB_NUMBER}?expand=1"
}

# Setting up TT
login_icr
check_dependencies

# Health Checks
polarhub_hc_medium
polarhub_hc_low

# Vulnerabilities
polarhub_vul_medium
polarhub_vul_low

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
