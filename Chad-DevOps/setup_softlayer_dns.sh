#!/usr/bin/env bash

IPADDRESS=""
BFROUTE=""
myIP="$(curl whatsmyip.fringe.ibm.com) && echo $myIP"

# Setting up Routing in resolv.conf
if [[ "for iproute in ${IPADDRESS}; do cat /etc/resolv.conf | grep $iprout != $iproute ; done " ]] ;
then
	[[ for ${DNS_IP} in ${IPADDRESS}  do; sed -i '$a nameserver ${DNS_IP}' /etc/resolve.conf; done ]];
else
	echo "resolve.conf is setup properly"
fi

# Setting up Route
if [[ ip route != ${BFROUTE}  ]] ;
then
 [[ ip route add ${ROUTE} via ${myIP} dev eth0 ]] ;
	;
else
	 echo "route is setup correctly" ;
fi

echo "testing DNS routing"
ip route | grep 9.0.0.0/24
ping -c 2  collector.api.innovate.ibm.com
nslookup -type=ns compute.c.ibm.com

# FILE1="/tmp/softlayer_dns/resolv.conf"
# FILE2="/etc/resolv.conf"

# Setting up resolv.conf
# if [[ cat /etc/resolv.conf | wc -l != 4 ]] ;
# then
# 	mv ${FILE1 {FILE2} ;
# else
# 	echo "resolv.conf is setup properly"
# fi
