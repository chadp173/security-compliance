#!/usr/bin/env bash
set -x

count=$(wc -l < /etc/ntp.conf)
line="59"
file1="/tmp/bf-ntp.conf"
file2="/etc/ntp.conf"

if [[ $count != $line ]] ;
	then  mv $file1 $file2 ;
else
   echo "NTP file is setup corretly" ;
fi
