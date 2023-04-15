#!/usr/bin/env python3

import subprocess

EDGE_MEDIUM = "ECN Medium & Low Image Vulnerabilities"
TT_VERSION = "tt_v1.4.0"
MASTER = "master_file"
RESULTS = "results"
EDGE_TAG = "latest"
ECN = "ecn"
MEDIUM = "M"
LOW = "L"
timestamp = subprocess.check_output(['date', '+%Y%m%d%T'])
timestamp = timestamp.decode('utf-8').strip()
subprocess.check_output(['chmod', '+x', 'files/tt_v1.4.0/linux_x86_64/tt'])
GH_HOST = "github.ibm.com"

def login_icr():
    subprocess.check_output(['curl', '-fsSL', 'https://clis.cloud.ibm.com/install/linux', '|', 'sh'])
    subprocess.check_output(['travis_wait', '30', 'ibmcloud', 'login', '-u', 'Chad.Perry1@ibm.com', '--apikey', '${ICR_API_KEY}', '-r', 'us-south'])
def check_dependencies():
    subprocess.check_output(['travis_wait', '30', 'files/tt_v1.4.0/linux_x86_64/tt', 'check-dependencies'])

#######################
# Edge Compute Nodes  #
#######################

def ecn_hc_medium():
    for EDGE_IMAGE in ['thousandeyes-enterprise-agent', 'edge-portal-keystone']:
        subprocess.check_output(['travis_wait', '30', 'files/' + TT_VERSION + '/linux_x86_64/tt', 'images', 'pull-and-scan', '-u', '${W3ID}:${TWISTLOCK_API}', '-g', 'eal_eal-010561', '-ik', '${ICR_API_KEY}', '-q', '--has-fix-filter', 'Y', '--issue-type-filter', 'C', '--severity-filter', 'M', 'us.icr.io/edge-compute/' + EDGE_IMAGE + ':' + EDGE_TAG, '-of', ECN + '-hc-' + EDGE_IMAGE + '-' + MEDIUM + '.csv'])
def ecn_vul_medium():
    for EDGE_IMAGE in ['thousandeyes-enterprise-agent', 'edge-portal-keystone']:
        subprocess.check_output(['travis_wait', '30', 'files/' + TT_VERSION + '/linux_x86_64/tt', 'images', 'pull-and-scan', '-u', '${W3ID}:${TWISTLOCK_API}', '-g', 'eal_eal-010561', '-ik', '${ICR_API_KEY}', '-q', '--has-fix-filter', 'Y', '--issue-type-filter', 'V', '--severity-filter', 'M', 'us.icr.io/edge-compute/' + EDGE_IMAGE + ':' + EDGE_TAG, '-of', ECN + '-vul-' + EDGE_IMAGE + '-' + MEDIUM + '.csv'])
