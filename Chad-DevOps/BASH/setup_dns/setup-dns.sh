#!/usr/bin/env bash

TEST=$(for X in 128 130; do cat /etc/resolv.conf | grep 9.0.${X}.50;done)
FIX=$(for P in 128 130; do echo nameserver 9.0.${P}.50 | tee -a /etc/resolv.conf;done)

BFROUTE="9.207.131.0/24"
#"9.0.0.0/8"

# Setting up Routing in resolv.conf
if [[ ${TEST} != -z ]] ;
then
   [[ $FIX  ]];
else
   echo "resolve.conf is setup properly";
fi

# Setting up Route
if [[ "ip route | grep ${BFROURE} -ne ${BFROUTE}" ]];
then
    echo "route is not defined for 9.0.0.0/8";
else
    echo "route is setup correctly" ;
fi

echo "Testing DNS routing"
#ip route | grep 9.0.0.0/8
ping -c 2  collector.api.innovate.ibm.com
#nslookup -type=ns compute.c.ibm.com

# FILE1="/tmp/softlayer_dns/resolv.conf"
# FILE2="/etc/resolv.conf"

# Setting up resolv.conf
# if [[ cat /etc/resolv.conf | wc -l != 4 ]] ;
# then
# 	mv ${FILE1 {FILE2} ;
# else
# 	echo "resolv.conf is setup properly"
# fi
