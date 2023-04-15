#!/usr/bin/env bash

## Allow incoming traffic for Docker Host
iptables -I INPUT -p tcp --dport 2375 -j ACCEPT -m comment --comment "Allow Docker Host connections"
iptables -I INPUT -p tcp --dport 8081 -j ACCEPT -m comment --comment "Allow BlueFringe app connections"
iptables -I INPUT -p tcp --dport 5000 -j ACCEPT -m comment --comment "Allow BlueFringe app connections"

iptables-save

## Make sure the iptables rules stays after reboot
sed -i 's/IPTABLES_SAVE_ON_RESTART="no"/IPTABLES_SAVE_ON_RESTART="yes"/g' /etc/sysconfig/iptables-config
sed -i 's/IPTABLES_SAVE_ON_STOP="no"/IPTABLES_SAVE_ON_STOP="yes"/g' /etc/sysconfig/iptables-config

