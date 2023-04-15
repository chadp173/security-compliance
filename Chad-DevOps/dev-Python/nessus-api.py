#!/usr/bin/python3.6
#https://programmer.help/blogs/using-python-to-call-nessus-interface-to-realize-automatic-scanning.html#_6

import requests
import json

def get_scan_list()
    accessKey = "XXXXXX" #Fill in the real content here
    secretKey = "XXXXXX" #Fill in the real content here

    url = "https://{ip}:{port}/scans".format(ip, port)
    token = get_token(ip, port, username, password)
    if token:
        header = {
            'X-ApiKeys': 'accessKey={accesskey};secretKey={secretkey}'.format(accesskey=accessKey, secretkey=secretKey)
            "Content-Type":"application/json"
        }
        response = requests.get(url, headers=header, verify=False)
        if response.status_code == 200:
            result = json.loads(respon.text)
            return result


def get_nessus_template_uuid(ip, port, template_name = "advanced"):
    header = {
        'X-ApiKeys': 'accessKey={accesskey};secretKey={secretkey}'.format(accesskey=accesskey,
                                                                          secretkey=secretkey),
        'Content-type': 'application/json',
        'Accept': 'text/plain'}

    api = "https://{ip}:{port}/editor/scan/templates".format(ip=ip, port=port)
    response = requests.get(api, headers=header, verify=False)
    templates = json.loads(response.text)['templates']

    for template in templates:
        if template['name'] == template_name:
            return template['uuid']
    return None
