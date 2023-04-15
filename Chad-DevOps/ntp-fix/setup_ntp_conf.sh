#!/usr/bin/env bash
set -x

test_serv=$(for P in 0 1 2 3; do cat /etc/ntp.conf | grep ${P}.centos.pool.ntp.org; done)
pub_serv=$(for C in 1 2 3; do cat /etc/ntp.conf | grep ntp${C}.adtech.internet.ibm.com; done)
file1="/tmp/bf-ntp.conf"
file2="/etc/ntp.conf"

if [ "$pub_serv" != "$test_serv" ] ;then
   mv $file1 $file2 ;
else
   echo "NTP file is setup correctly" ;
   exit 0
fi

for C in 1 2 3; do cat /etc/ntp.conf | grep ntp${C}.adtech.internet.ibm.com; done
