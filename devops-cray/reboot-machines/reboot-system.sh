root@sms01.jolt2:~ # cat /root/bin/reboot-system.sh
#!/bin/bash
#
# reboot-system.sh - Steps normally done by squashfs-deploy which
# need to be run post boot. This script reboots all nodes in /root/nodelist
# then configures and brings up the HSN NICs.  It does not affect the
# Rosetta side of the HSN connections.
#

date

echo -e "\nRebooting all compute nodes\n"

!#/usr/bin/env bash 
# reboot-nodes.sh 

for i in `cat /root/comp-bmc-ip`; do ipmitool -I lanplus -U root -P initial0 -H $i chassis power off; done
for i in `cat /root/comp-bmc-ip`; do ipmitool -I lanplus -U root -P initial0 -H $i chassis power on; done
echo -e "\nWaiting for nodes to boot.\n"
echo -e "\nConfiguring and starting the HSN interfaces.\n"
pdsh dhclient
pdsh /scratch/ifcfg-hsn/config-hsn.sh

# Start slurmd on all the computes
echo -e "\nStarting slurmd on all computes.\n"
pdsh "systemctl start slurmd "
echo -e "\nStarting slurmctld on nid000001-nmn.\n"
ssh -o StrictHostKeyChecking=no nid000001-nmn "systemctl start slurmctld"

# Turn off memory overcommit on computes...SKERN-1264 work around.
pdsh 'echo 2 > /proc/sys/vm/overcommit_memory'

# Configure LDAP and restart nscd to enable LDAP authentication
#echo -e "\nConfiguring LDAP user authentication.\n"

# Add net route to LDAP servers to point to sms02,
# which has IPforwarding and NAT set up
pdsh 'route add -net  172.30.74.0/24 gw 10.2.0.2'
pdsh 'route add -net  172.30.79.0/24 gw 10.2.0.2'
pdsh 'authconfig --enablepamaccess --enablelocauthorize --enableldap --enableldapauth --ldapserver=ldap://172.30.79.14,ldap://172.30.79.134 --ldapbasedn="dc=datacenter,dc=cray,dc=com" --enablecache --disablefingerprint --kickstart'
pdsh 'echo "session     required      pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/password-auth'
pdsh systemctl restart nscd
#
echo -e "\nMounting Lustre FS, /lus/snx11259 \n"
#
#  Add route to snx11259
pdsh 'ip route add 10.10.0.0/16 via 169.254.255.254'
pdsh mount /lus/snx11259

