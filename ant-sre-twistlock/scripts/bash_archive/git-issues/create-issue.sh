#!/usr/bin/env bash 
set -x 

############################################# 
# IBM CIO Network Engineering:
# AnT Twistlock AAAaaS
# Chad Perry <Chad.Perry1@us.ibm.com>
# This tool will:
#   Install GitHub CLI 
#   Open a GitHub Issue that relates to PR
############################################

timestamp=$(date +"%Y%m%d%T")

install_gh_cli() {
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update -y 
sudo apt install gh -y 
}

gh_auth() {
export GH_HOST=github.ibm.com; echo ${GITHUB_API_TOKEN}  | gh auth login --hostname github.ibm.com --with-token
}

create_issues() {
git config user.email ${W3ID}
git config user.name ${GITHUB_USER}
export GH_REPO=NetEngTools/ant-sre-twistlock-reports
gh issue create --title "Twistlock Travis Build: ${TRAVIS_JOB_NUMBER}" --body "GitHub PR: https://github.ibm.com/NetEngTools/ant-sre-twistlock-reports/compare/Twistlock-${TRAVIS_JOB_NUMBER}?expand=1" 
}

#functions
install_gh_cli
gh_auth
create_issues
