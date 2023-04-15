#!/usr/bin/env bash
# Set the access token

access_token=""
KEY_FILE=""
KEY_USER=""

function login(){
   bash $PWD/bin/appscan.sh api_login -P ${KEY_FILE} -u ${KEY_USER} -persist
   bash $PWD/bin/appscan.sh update
   bash $PWD/bin/appscan.sh checkUpdate
}
function irx(){
  appscan.sh prepare -c $PWD/ant-sre-sast-appscan/ciocssp-core-appscan-config.xml -d . -s deep --sourceCodeOnly -oso
}

function scan(){
  # Initiate the scan and retrieve the job ID
  response=$(curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $access_token" -d '{ "scanRequest": { "scanTypeId": 1, "profileId": 1, "websiteId": 1, "scanName": "My Scan" } }' https://cloud.appscan.com/api/v2/scans)
  job_id=$(echo $response | jq -r '.jobId')

  # Queue the analysis using the job ID
  $PWD/bin/appscan.sh queue_analysis -a $APP_ID -f $PWD/${DESTINATION_FOLDER_NAME}/${1}.irx -n $2 -j $jobIdd
}
#function analysis(){
#  appscan.sh queue_analysis -a <app_id> -f <irx_file> -n <scan_name>
#}

#function results() {
#  # Retrieve the scan results using the job
#  appscan.sh get_result -d <file_path> -i $jobIdd -t <type>
#}

#function report() {
#  appscan.sh get_report -d <file_path> -f <format> -i <target_id> -locale <locale> -rt <reg_type> -s <scope> -t <type> -title <title> -applyPolicies
#}