#!/usr/bin/python3.6
# https://programmer.help/blogs/using-python-to-call-nessus-interface-to-realize-automatic-scanning.html#_522

import requests
import json

def get_scan_list()
    accessKey = "6bb4de1d4679e9f6eea8d405389b226e3a5f4ae1387ea5c15b4732f4c54befe0" #Fill in the real content here
    secretKey = "4e8fddc1dfe2d648fcd48d2c9f4fb50c32ef724bdb710268d7032152f79e0d57" #Fill in the real content here
        
    url = "https://{9.45.125.104}:{8834}/scans".format(ip, port)
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


def create_template(ip, port, **kwargs): # kwargs as an optional parameter to configure settings and other items
    header = {
        "X-ApiKeys": "accessKey={accesskey};secretKey={secretkey}".format(accesskey=accesskey,
                                                                          secretkey=secretkey),
        "Content-Type": "application/json",
        "Accept": "text/plain"
    }
    policys = {}

    # Here, grouppolicy set stores the name of each script in the policy template and whether the script is enabled or not
    for policy in grouppolicy_set:
        enabled = "enabled" if policy.enable else "disabled"
        policys[policy.name] = {
            "status": enabled
        }
    
    # Each item in settings must be brought, otherwise it will not be created successfully
    "settings": {
        "name": template.name,
        "watchguard_offline_configs": "",
        "unixfileanalysis_disable_xdev": "no",
        "unixfileanalysis_include_paths": "",
        "unixfileanalysis_exclude_paths": "",
        "unixfileanalysis_file_extensions": "",
        "unixfileanalysis_max_size": "",
        "unixfileanalysis_max_cumulative_size": "",
        "unixfileanalysis_max_depth": "",
        "unix_docker_scan_scope": "host",
        "sonicos_offline_configs": "",
        "netapp_offline_configs": "",
        "junos_offline_configs": "",
        "huawei_offline_configs": "",
        "procurve_offline_configs": "",
        "procurve_config_to_audit": "Saved/(show config)",
        "fortios_offline_configs": "",
        "fireeye_offline_configs": "",
        "extremeos_offline_configs": "",
        "dell_f10_offline_configs": "",
        "cisco_offline_configs": "",
        "cisco_config_to_audit": "Saved/(show config)",
        "checkpoint_gaia_offline_configs": "",
        "brocade_offline_configs": "",
        "bluecoat_proxysg_offline_configs": "",
        "arista_offline_configs": "",
        "alcatel_timos_offline_configs": "",
        "adtran_aos_offline_configs": "",
        "patch_audit_over_telnet": "no",
        "patch_audit_over_rsh": "no",
        "patch_audit_over_rexec": "no",
        "snmp_port": "161",
        "additional_snmp_port1": "161",
        "additional_snmp_port2": "161",
        "additional_snmp_port3": "161",
        "http_login_method": "POST",
        "http_reauth_delay": "",
        "http_login_max_redir": "0",
        "http_login_invert_auth_regex": "no",
        "http_login_auth_regex_on_headers": "no",
        "http_login_auth_regex_nocase": "no",
        "never_send_win_creds_in_the_clear": "yes" if kwargs["never_send_win_creds_in_the_clear"] else "no",
        "dont_use_ntlmv1": "yes" if kwargs["dont_use_ntlmv1"] else "no",
        "start_remote_registry": "yes" if kwargs["start_remote_registry"] else "no",
        "enable_admin_shares": "yes" if kwargs["enable_admin_shares"] else "no",
        "ssh_known_hosts": "",
        "ssh_port": kwargs["ssh_port"],
        "ssh_client_banner": "OpenSSH_5.0",
        "attempt_least_privilege": "no",
        "region_dfw_pref_name": "yes",
        "region_ord_pref_name": "yes",
        "region_iad_pref_name": "yes",
        "region_lon_pref_name": "yes",
        "region_syd_pref_name": "yes",
        "region_hkg_pref_name": "yes",
        "microsoft_azure_subscriptions_ids": "",
        "aws_ui_region_type": "Rest of the World",
        "aws_us_east_1": "",
        "aws_us_east_2": "",
        "aws_us_west_1": "",
        "aws_us_west_2": "",
        "aws_ca_central_1": "",
        "aws_eu_west_1": "",
        "aws_eu_west_2": "",
        "aws_eu_west_3": "",
        "aws_eu_central_1": "",
        "aws_eu_north_1": "",
        "aws_ap_east_1": "",
        "aws_ap_northeast_1": "",
        "aws_ap_northeast_2": "",
        "aws_ap_northeast_3": "",
        "aws_ap_southeast_1": "",
        "aws_ap_southeast_2": "",
        "aws_ap_south_1": "",
        "aws_me_south_1": "",
        "aws_sa_east_1": "",
        "aws_use_https": "yes",
        "aws_verify_ssl": "yes",
        "log_whole_attack": "no",
        "enable_plugin_debugging": "no",
        "audit_trail": "use_scanner_default",
        "include_kb": "use_scanner_default",
        "enable_plugin_list": "no",
        "custom_find_filepath_exclusions": "",
        "custom_find_filesystem_exclusions": "",
        "reduce_connections_on_congestion": "no",
        "network_receive_timeout": "5",
        "max_checks_per_host": "5",
        "max_hosts_per_scan": "100",
        "max_simult_tcp_sessions_per_host": "",
        "max_simult_tcp_sessions_per_scan": "",
        "safe_checks": "yes",
        "stop_scan_on_disconnect": "no",
        "slice_network_addresses": "no",
        "allow_post_scan_editing": "yes",
        "reverse_lookup": "no",
        "log_live_hosts": "no",
        "display_unreachable_hosts": "no",
        "report_verbosity": "Normal",
        "report_superseded_patches": "yes",
        "silent_dependencies": "yes",
        "scan_malware": "no",
        "samr_enumeration": "yes",
        "adsi_query": "yes",
        "wmi_query": "yes",
        "rid_brute_forcing": "no",
        "request_windows_domain_info": "no",
        "scan_webapps": "no",
        "start_cotp_tsap": "8",
        "stop_cotp_tsap": "8",
        "modbus_start_reg": "0",
        "modbus_end_reg": "16",
        "hydra_always_enable": "yes" if kwargs["hydra_always_enable"] else "no",
        "hydra_logins_file": "" if kwargs["hydra_logins_file"] else kwargs["hydra_logins_file"], # The weak password file needs to be uploaded in advance, and the upload file interface will be mentioned later
        "hydra_passwords_file": "" if kwargs["hydra_passwords_file"] else kwargs["hydra_passwords_file"],
        "hydra_parallel_tasks": "16",
        "hydra_timeout": "30",
        "hydra_empty_passwords": "yes",
        "hydra_login_as_pw": "yes",
        "hydra_exit_on_success": "no",
        "hydra_add_other_accounts": "yes",
        "hydra_postgresql_db_name": "",
        "hydra_client_id": "",
        "hydra_win_account_type": "Local accounts",
        "hydra_win_pw_as_hash": "no",
        "hydra_cisco_logon_pw": "",
        "hydra_web_page": "",
        "hydra_proxy_test_site": "",
        "hydra_ldap_dn": "",
        "test_default_oracle_accounts": "no",
        "provided_creds_only": "yes",
        "smtp_domain": "example.com",
        "smtp_from": "nobody@example.com",
        "smtp_to": "postmaster@[AUTO_REPLACED_IP]",
        "av_grace_period": "0",
        "report_paranoia": "Normal",
        "thorough_tests": "no",
        "detect_ssl": "yes",
        "tcp_scanner": "no",
        "tcp_firewall_detection": "Automatic (normal)",
        "syn_scanner": "yes",
        "syn_firewall_detection": "Automatic (normal)",
        "wol_mac_addresses": "",
        "wol_wait_time": "5",
        "scan_network_printers": "no",
        "scan_netware_hosts": "no",
        "scan_ot_devices": "no",
        "ping_the_remote_host": "yes",
        "tcp_ping": "yes",
        "icmp_unreach_means_host_down": "no",
        "test_local_nessus_host": "yes",
        "fast_network_discovery": "no",
        "arp_ping": "yes" if kwargs["arp_ping"] else "no",
        "tcp_ping_dest_ports": kwargs["tcp_ping_dest_ports"],
        "icmp_ping": "yes" if kwargs["icmp_ping"] else "no",
        "icmp_ping_retries": kwargs["icmp_ping_retries"],
        "udp_ping": "yes" if kwargs["udp_ping"] else "no",
        "unscanned_closed": "yes" if kwargs["unscanned_closed"] else "no",
        "portscan_range": kwargs["portscan_range"],
        "ssh_netstat_scanner": "yes" if kwargs["ssh_netstat_scanner"] else "no",
        "wmi_netstat_scanner": "yes" if kwargs["wmi_netstat_scanner"] else "no",
        "snmp_scanner": "yes" if kwargs["snmp_scanner"] else "no",
        "only_portscan_if_enum_failed": "yes" if kwargs["only_portscan_if_enum_failed"] else "no",
        "verify_open_ports": "yes" if kwargs["verify_open_ports"] else "no",
        "udp_scanner": "yes" if kwargs["udp_scanner"] else "no",
        "svc_detection_on_all_ports": "yes" if kwargs["svc_detection_on_all_ports"] else "no",
        "ssl_prob_ports": "Known SSL ports" if kwargs["ssl_prob_ports"] else "All ports",
        "cert_expiry_warning_days": kwargs["cert_expiry_warning_days"],
        "enumerate_all_ciphers": "yes" if kwargs["enumerate_all_ciphers"] else "no",
        "check_crl": "yes" if kwargs["check_crl"] else "no",
   }
    
    credentials = {
            "add": {
                "Host": {
                    "SSH": [],
                    "SNMPv3": [],
                    "Windows": [],
                },
                "Plaintext Authentication": {
                    "telnet/rsh/rexec": []
                }
            }
        }
        try:
            if kwargs["snmpv3_username"] and kwargs["snmpv3_port"] and kwargs["snmpv3_level"]:
                level = kwargs["snmpv3_level"]
                if level == NessusSettings.LOW:
                    credentials["add"]["Host"]["SNMPv3"].append({
                        "security_level": "No authentication and no privacy",
                        "username": kwargs["snmpv3_username"],
                        "port": kwargs["snmpv3_port"]
                    })
                elif level == NessusSettings.MID:
                    credentials["add"]["Host"]["SNMPv3"].append({
                        "security_level": "Authentication without privacy",
                        "username": kwargs["snmpv3_username"],
                        "port": kwargs["snmpv3_port"],
                        "auth_algorithm": NessusSettings.AUTH_ALG[kwargs["snmpv3_auth"][1]],
                        "auth_password": kwargs["snmpv3_auth_psd"]
                    })
                elif level == NessusSettings.HIGH:
                    credentials["add"]["Host"]["SNMPv3"].append({
                        "security_level": "Authentication and privacy",
                        "username": kwargs["snmpv3_username"],
                        "port": kwargs["snmpv3_port"],
                        "auth_algorithm": NessusSettings.AUTH_ALG[kwargs["snmpv3_auth"]][1],
                        "auth_password": kwargs["snmpv3_auth_psd"],
                        "privacy_algorithm": NessusSettings.PPIVACY_ALG[kwargs["snmpv3_hide"]][1],
                        "privacy_password": kwargs["snmpv3_hide_psd"]
                    })

            if kwargs["ssh_username"] and kwargs["ssh_psd"]:
                credentials["add"]["Host"]["SSH"].append(
                    {
                        "auth_method": "password",
                        "username": kwargs["ssh_username"],
                        "password": kwargs["ssh_psd"],
                        "elevate_privileges_with": "Nothing",
                        "custom_password_prompt": "",
                    })

            if kwargs["windows_username"] and kwargs["windows_psd"]:
                credentials["add"]["Host"]["Windows"].append({
                    "auth_method": "Password",
                    "username": kwargs["windows_username"],
                    "password": kwargs["windows_psd"],
                    "domain": kwargs["ssh_host"]
                })

            if kwargs["telnet_username"] and kwargs["telnet_password"]:
                credentials["add"]["Plaintext Authentication"]["telnet/rsh/rexec"].append({
                    "username": kwargs["telnet_username"],
                    "password": kwargs["telnet_password"]
                })
    
    data = {
            "uuid": get_nessus_template_uuid(terminal, "advanced"),
            "settings": settings,
            "plugins": policys,
            "credentials": credentials
        }
    
    api = "https://{0}:{1}/policies".format(ip, port)
    response = requests.post(api, headers=header, data=json.dumps(data, ensure_ascii=False).encode("utf-8"), # Here we do a transcoding to prevent Chinese miscoding at nessus
                             verify=False)
    if response.status_code == 200:
        data = json.loads(response.text)
        return data["policy_id"] # Returns the id of the policy template, which can be used later when creating tasks
    else:
        return None

def create_task(task_name, policy_id, hosts): # host is a list of multiple hosts that need to be scanned
    uuid = get_nessus_template_uuid(terminal, "custom") # Get uuid of custom policy
    if uuid is None:
        return False

    data = {"uuid": uuid, "settings": {
        "name": name,
        "policy_id": policy_id,
        "enabled": True,
        "text_targets": hosts,
        "agent_group_id": []
    }}

    header = {
        'X-ApiKeys': 'accessKey={accesskey};secretKey={secretkey}'.format(accesskey=accesskey,
                                                                          secretkey=secretkey),
        'Content-type': 'application/json',
        'Accept': 'text/plain'}

    api = "https://{ip}:{port}/scans".format(ip=terminal.ip, port=terminal.port)
    response = requests.post(api, headers=header, data=json.dumps(data, ensure_ascii=False).encode("utf-8"),
                             verify=False)
    if response.status_code == 200:
        data = json.loads(response.text)
        if data["scan"] is not None:
            scan = data["scan"]
            # New task extension information record

            return scan["id"] # Return task id


def get_task_status(task_id):
    header = {
        "X-ApiKeys": "accessKey={accesskey};secretKey={secretkey}".format(accesskey=accesskey,
                                                                          secretkey=secretkey),
        "Content-Type": "application/json",
        "Accept": "text/plain"
    }

    api = "https://{ip}:{port}/scans/{task_id}".format(ip=ip, port=port,
                                                       task_id=task_id)
    response = requests.get(api, headers=header, verify=False)
    if response.status_code != 200:
        return 2, "Data Error"

    data = json.loads(response.text)
    hosts = data["hosts"]
    for host in hosts:
        get_host_vulnerabilities(scan_id, host["host_id"]) # Get vulnerability information by host

    if data["info"]["status"] == "completed" or data["info"]["status"] =='canceled':
        # Finished, update local task status
    return 1, "OK"


def get_host_vulnerabilities(scan_id, host_id):
    header = {
        "X-ApiKeys": "accessKey={accesskey};secretKey={secretkey}".format(accesskey=accesskey,
                                                                          secretkey=secretkey),
        "Content-Type": "application/json",
        "Accept": "text/plain"
    }

    scan_history = ScanHistory.objects.get(id=scan_id)
    api = "https://{ip}:{port}/scans/{task_id}/hosts/{host_id}".format(ip=ip, port=port, task_id=scan_id, host_id=host_id)
    response = requests.get(api, headers=header, verify=False)
    if response.status_code != 200:
        return 2, "Data Error"

    data = json.loads(response.text)
    vulns = data["vulnerabilities"]
    for vuln in vulns:
        vuln_name = vuln["plugin_name"]
        plugin_id = vuln["plugin_id"] #Plug in id, which can obtain more detailed information, including plug-in information and solutions scanned to vulnerabilities
        #Save vulnerability information
