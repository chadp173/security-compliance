#!/usr/bin/env bash 


ROUTE="9.0.0.0/8"
myIP=$(curl whatsmyip.fringe.ibm.com) && echo $myIP

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
if [[ ip route = ${ROUTE}  ]] ; 
then  
	echo "route is setup correctly" ;
else 
	[[ ip route add 9.0.0.0/8 via ${myIP} dev eth0 ]]
fi 
