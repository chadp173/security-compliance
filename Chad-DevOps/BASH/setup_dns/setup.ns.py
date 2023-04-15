#!/usr/bin/env python3
"""
IBM CIO Network Engineering:
AnT Fix Softlayer DNS
Chad Perry <Chad.Perry1@ibm.com>
This tool will:
Read the DNS file
Verify two nameservers are present
Add the nameservers if missing
Create the route 9.0.0.0/8
Test abd Verification of Routing tables
Test and Verify ping to collector Server
"""
import shutil
import os
import subprocess

from typing import List
file        = open('/etc/resolv.conf', "r+")
fs          = open('/etc/resolv.conf', "a+")
flag        = 0
dns_index   = 0
dns_config = ['9.0.128.50', '9.0.130.50']
rt_cmd      = '["ip route | grep 9.0.0.0/8 != 9.0.0.0/8"]'
notset      = os.system(rt_cmd)

def check_dns():
    for line in file:
        dns_index += 1

        if dns_config in line:
            flag == 1
            break

            if flag == 0:
                print("DNS is not setup correctly")
            elif fs.write('nameserver 9.0.128.50\n'):
                 fs.write('nameserver 9.0.130.50\n')
            else: print("DSN file is fixed")
            fs.close()

            if not subprocess.run[(rt_cmd)]:
                print("DNS Routing is setup")
            else:
                print("routing is not configured")

            subprocess.run[(p_cmd)]
            subprocessrun[(dig )]

if __name__=='__check_dns()__':
    check_dns()

def subprocess_cmd(command):
    process = subprocess(command, stdout=subprocess, shell=True)
    proc_stdout = process.communicate()[0].strip()
    print ("proc_stdout")

subprocess_cmd('ping -c 2  collector.api.innovate.ibm.com')

if "__subprocessor_cmd" == __name__:
    subprocess()

# # Append a File in Python
# def dns_append():
#     fs = open('/etc/resolv.conf', "a+")
#     fs.write("nameserver 9.0.128.50\n")
#     fs.write("nameserver 9.0.130.50\n")
#     fs.close()

# if __name__=='__dns_append__':
#     dns_append()
# TODO fix line 53,57
"""
Traceback (most recent call last):
  File "./setup_softlayer_dns.py", line 57, in <module>
    subprocess_cmd('ip route | grep 9.0.0.0/24; ping -c 2  collector.api.innovate.ibm.com')
  File "./setup_softlayer_dns.py", line 53, in subprocess_cmd
    process = subprocess(command, stdout=subprocess, shell=True)
TypeError: 'module' object is not callable
"""

# # Setting DSN Route
# def set_route():
#     rt_cmd = '["ip route | grep 9.0.0.0/8 != 9.0.0.0/8"]'
#     notset = os.system(rt_cmd)
#     fix_cmd = "ip route add 9.0.0.0/8 via myIP dev eth0"
#     rtset = os.system(fix_cmd)

#     if os.system(rt_cmd):
#         print("routing is not configured")
#     else: os.system(fix_cmd)
#
# if __init__=='__set_route__':
#     set_route()


# # Reading /etc/resolv.conf
# def dns_explore():
#     fs = open('/etc/resolv.conf', "r+")
#     fs.read()
#     fs.close()
#
# if "__init__" == __name__:
#     dns_explore()


# # Testing and verification
# def subprocess_cmd(command):
#     process = subprocess(command, stdout=subprocess, shell=True)
#     proc_stdout = process.communicate()[0].strip()
#     print ("proc_stdout")


# subprocess_cmd('ip route | grep 9.0.0.0/24; ping -c 2  collector.api.innovate.ibm.com')
#
# if "__subprocessor_cmd" == __name__:
#     subprocess()

# route = "ip route | grep 9.0.0.0/24"
#
# return_value = os.system(route)
#
# os.ping("ping -c")"
# os.route("ip route | grep 9.0.0.0/24")

# os.ping("ping -c")
# os.dbs("nslookup -type=ns")
#
# ip route | grep 9.0.0.0/24
# ping -c 2  collector.api.innovate.ibm.com
# nslookup -type=ns compute.c.ibm.com
