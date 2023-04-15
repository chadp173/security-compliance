#!/usr/bin/env bash
set -x

sudo yum install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld

sudo firewall-cmd --permanent --zone=public --add-port=10250/udp
sudo firewall-cmd --permanent --zone=public --add-port=10250/tcp
sudo firewall-cmd --zone=public --permanent --add-port=30000-32767/udp
sudo firewall-cmd --zone=public --permanent --add-port=30000-32767/tcp
sudo  firewall-cmd --reload

sudo  firewall-cmd --list-all >> /tmp/firewall.log
