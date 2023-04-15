#!/usr/bin/env bash
set -x
sudo yum install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld

sudo firewall-cmd --permanent --zone=public --add-port=6443/udp
sudo firewall-cmd --permanent --zone=public --add-port=6443/tcp
sudo firewall-cmd --zone=public --permanent --add-port=2379-2380/udp
sudo firewall-cmd --zone=public --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --permanent --zone=public --add-port=10250/udp
sudo firewall-cmd --permanent --zone=public --add-port=10250/tcp
sudo firewall-cmd --permanent --zone=public --add-port=10251/udp
sudo firewall-cmd --permanent --zone=public --add-port=10251/tcp
sudo firewall-cmd --permanent --zone=public --add-port=10252/udp
sudo firewall-cmd --permanent --zone=public --add-port=10252/tcp
sudo firewall-cmd --permanent --zone=public --add-port=6763/tcp
sudo firewall-cmd --permanent --zone=public --add-port=6783/udp
sudo firewall-cmd --permanent --zone=public --add-port=6784/udp
sudo  firewall-cmd --reload
sudo  firewall-cmd --list-all >> /tmp/firewall.log
