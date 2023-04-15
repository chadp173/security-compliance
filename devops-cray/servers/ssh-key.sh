#!/usr/bin/env bash

mkidr -p /home/$(whoami)/.ssh 
touch /home/$(whoami)/.ssh/authorized_keys
cat >> /home/$(whoami)/.ssh/authorized_keys << EOM
ADD_PUBLIC_KEY
EOM


yum install wget curl git -y 

