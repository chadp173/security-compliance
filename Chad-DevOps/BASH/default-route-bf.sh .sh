#!/usr/bin/env bash 

NET-ROUTE="ip route"
ROUTE=""
IP=files/

check_status()
{
        result=$?
        if [ ${result} -ne 0 ] ; then
                echo -e "\e[01;31m[ERROR] $@ \e[00m"
                exit;
        fi
}


if [[ ip route | grep "9.0.0.0/8" | grep "dev" | grep eth0 == "True" ]] ; 
then  
	echo "route is setup correctly" ;
else 
	[ ip route add 9.0.0.0/8 via ${p} dev eth0 ]
if 

echo "Define Route"
ip route | grep "9.0.0.0/8" | grep "dev" | grep "eth0"






ip route add 9.0.0.0/8 via {{ip.addresss}} dev eth0
ip route | grep "9.0.0.0/8" | grep "dev" | grep eth0 
