#!/usr/bin/env bash 

NET-ROUTE="ip route"
ROUTE=""
IP=files/

# Setting up resolv.conf
if [[ cat /etc/resolv.conf | wc -l != 2 ]] ;
then 
cat <<DOA >> /etc/resolv.conf
nameserver 9.0.128.50
nameserver 9.0.130.50
DOA
else ; 
	echo "resolv.conf is setup properly"
fi  

# Setting up Route
if [[ ip route | grep "9.0.0.0/8" | grep "dev" | grep eth0 == "True" ]] ; 
then  
	echo "route is setup correctly" ;
else 
	[ ip route add 9.0.0.0/8 via ${p} dev eth0 ]
fi 

