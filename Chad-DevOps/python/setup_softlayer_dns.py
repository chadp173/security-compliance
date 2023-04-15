#!/usr/bin/env python

import os re sys argparse

# Variables
path = '/etc/resolv.conf'
dns_names = ['nameserver 9.0.128.50', 'nameserver 9.0.130.50']
dns_list = ['9.0.128.500', '9.0.130.50']
file = open("/etc/resolv.conf", "r")
append_dns = ("/etc/resolv.conf", "a")
flag = 0
index = 0

# TODO Finish class function
class search_dns:
	def _init_self

for line in file:
	index + = 1

	if dns_list in line:
		flag = 1
		break

if flag == 0:
	print("DNS is not setup correctly") # run class function 2
else:
	print("DNS is setup correctly")

file.close()


# TODO Finish class function
class append:
	def _init_self

# Append
file = ("/etc/resolv.conf", "a")
file.write("nameserver 9.0.128.50 \n", "nameserver 9.0.130.50")
file.close()

# Setting Route
BFROUTE = "9.0.0.0/8"

if ip route != BFROUTE:
	print("routing is not configured")
elif:
	ip route add 9.0.0.0/8 via myIP dev eth0
else:
	print("route is setup correctly") # test class function, read file

# Reading file
file = open("/etc/resolv.conf", "r")
print("Checking resolv.conf")
print(file.read())
file.close

# Test
ip route | grep 9.0.0.0/24
ping -c 2  collector.api.innovate.ibm.com
nslookup -type=ns compute.c.ibm.com

