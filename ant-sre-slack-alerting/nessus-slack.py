import os
import requests
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

# Set up your ServiceNow credentials and instance URL
SERVICENOW_USERNAME = 'your_servicenow_username'
SERVICENOW_PASSWORD = 'your_servicenow_password'
SERVICENOW_INSTANCE = 'https://ibm.service-now.com'

# Set up your Slack bot token
SLACK_BOT_TOKEN = 'your_slack_bot_token'
SLACK_CHANNEL = '#your-slack-channel'

# Set up the ServiceNow API endpoint and headers
SN_API_ENDPOINT = f'{SERVICENOW_INSTANCE}/api/now/table/vulnerability'
SN_API_HEADERS = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
}

# Set up the Slack client
slack_client = WebClient(token=SLACK_BOT_TOKEN)

def get_vulnerabilities():
    try:
        response = requests.get(
            SN_API_ENDPOINT,
            auth=(SERVICENOW_USERNAME, SERVICENOW_PASSWORD),
            headers=SN_API_HEADERS
        )
        response.raise_for_status()
        return response.json()['result']
    except requests.exceptions.HTTPError as err:
        print(f'An error occurred while fetching vulnerabilities: {err}')
        return []

def send_to_slack(vulnerabilities):
    for vulnerability in vulnerabilities:
        message = f"*{vulnerability['number']}*: {vulnerability['short_description']}\nLink: {SERVICENOW_INSTANCE}/{vulnerability['sys_id']}"
        try:
            slack_client.chat_postMessage(
                channel=SLACK_CHANNEL,
                text=message
            )
        except SlackApiError as e:
            print(f"Error sending message: {e}")

def main():
    vulnerabilities = get_vulnerabilities()
    if vulnerabilities:
        send_to_slack(vulnerabilities)
    else:
        print('No vulnerabilities found.')
        
if __name__ == '__main__':
    main()
