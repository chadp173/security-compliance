#/bin/bash
echo " !!! TEMPORARY SOLUTION TO ASSIST WITH PREVIEW SYSTEMS !!!"
echo " !!! ONLY TO BE USED ON SINGLE CABINETS SETUP LIKE PREVIEW !!!"
echo " !!! ENTER TO CONTINUE, CTRL+C TO ABORT !!!"
read foo


# TODO: if we need something like this, re-do in python
# NOTE! Currently only works on single cabinet system. -dkinney
# 1. Temporary hack to create network bootable image with ssh keys
# for discovering hardware for the first time. Mostly borrowed from Dave Rush.
# 2. Setup system for pxe booting unknown computes.
# 3. After compute images are booted, ipmi can be set and mac address recoreded.

set -x
set -e

IFACE="vlan002"
CHROOT_DIR=/tmp/crayctl_discovery
SLES_REPO="file:/srv/www/htdocs/blob/shasta-cd-repo/sles15/"

################################################################################
# Shared Functions
################################################################################
function cleanup {
    umount "${CHROOT_DIR}"/dev
}

function create_boot_image() {
    # Use zypper to construct a 64bit chroot environment
    # This image is used to boot nodes for the first time
    [ ! -e /tmp/crayctl_discovery ] && mkdir /tmp/crayctl_discovery


    if [[ -d "${CHROOT_DIR}" ]]; then
        echo "Sysroot directory exists, deleting: ${CHROOT_DIR}"
        rm -Rf "${CHROOT_DIR}"
    fi

    mkdir -p "${CHROOT_DIR}"
    mkdir "${CHROOT_DIR}"/dev
    mount -o bind /dev ${CHROOT_DIR}/dev

    # Add repositories:
    zypper --root ${CHROOT_DIR} ar --no-gpgcheck ${SLES_REPO} base
    zypper --root ${CHROOT_DIR} --non-interactive refresh

    # Install base software and other nice things:
    zypper --root ${CHROOT_DIR} --non-interactive --no-gpg-checks \
        install -l patterns-base-minimal_base zypper openssh dhcp-client ipmitool

    zypper --root ${CHROOT_DIR} --non-interactive --no-gpg-checks \
        install -l kernel-default kernel-firmware

    # Create /init symlink to systemd. These are the only things really
    # needed to get this image to boot.
    touch ${CHROOT_DIR}/etc/fstab
    ln -sf usr/lib/systemd/systemd ${CHROOT_DIR}/init

    echo "root:initial0" >${CHROOT_DIR}/tmp/foo
    chroot ${CHROOT_DIR} chpasswd < ${CHROOT_DIR}/tmp/foo
    rm ${CHROOT_DIR}/tmp/foo

    # This other stuff is nice to have. It configures the first two Ethernet
    # device with DHCP & enables sshd
    cat << EOF > ${CHROOT_DIR}/etc/sysconfig/network/ifcfg-eth0
BOOTPROTO='dhcp'
STARTMODE='auto'
DHCLIENT_SET_HOSTNAME='yes'
DHCLIENT_HOSTNAME_OPTION='no'
EOF

    cat << EOF > ${CHROOT_DIR}/etc/sysconfig/network/ifcfg-eth1
BOOTPROTO='dhcp'
STARTMODE='auto'
DHCLIENT_SET_HOSTNAME='yes'
DHCLIENT_HOSTNAME_OPTION='no'
EOF

    chroot ${CHROOT_DIR} \
        ln -sf /usr/lib/systemd/system/multi-user.target /etc/systemd/system/default.target

    chroot ${CHROOT_DIR} \
        systemctl enable sshd

    # This is SuSE specific stuff... zypper complains unless it's set up correctly.
    chroot ${CHROOT_DIR} \
        ln -sf SLES.prod /etc/products.d/baseproduct

    # Make keys on sms if we don't have any
    [ ! -e /root/.ssh/id_rsa.pub ] && {
      ssh-keygen -f /root/.ssh/id_rsa -N ''
    }

    # add ssh keys
    cp -rp /etc/ssh/* ${CHROOT_DIR}/etc/ssh/
    mkdir -p ${CHROOT_DIR}/root/.ssh/
    cp -p /root/.ssh/id_rsa /root/.ssh/id_rsa.pub ${CHROOT_DIR}/root/.ssh/
    cat /root/.ssh/id_rsa.pub >> ${CHROOT_DIR}/root/.ssh/authorized_keys

    echo "Building CPIO"
    cd ${CHROOT_DIR}
    find . | cpio -H newc -o | pigz > ../crayctl.img
    cd ..
    cp crayctl.img /tmp/initrd15.gz
    cp ${CHROOT_DIR}/boot/vmlinuz /tmp/vmlinuz15

    echo "Successfully created network boot image."
    cleanup
    sleep 2
}

function make_expect_script() {
    # Stub that will ssh to switch and get mac address table
    # ONLY good for preview system. Lots of hardcoding.
    cat > /tmp/macs-expect << EOF
#!/usr/bin/expect
set timeout 60
# Nasty hackery to get mac-address table from dell 3048
# Only ready for shasta preview
spawn ssh -o StrictHostKeyChecking=no admin@10.4.255.254 "show mac-address-table"
expect "password:"
send "initial0\n"
expect eof
EOF

    # Make our script executable.
   chmod 777 /tmp/macs-expect
}

function get_macs() {
   # Query the first switch and get mac addresses.
   echo "Querying the switch to get mac addresses..."
   [ -e /tmp/out ] && rm -rf /tmp/out
   [ -e /tmp/switch-macs ] && rm -rf /tmp/switch-macs
   make_expect_script
   # Get all the mac addresses from the switch on vlan2, exclude 1/1 and 2/1 as it's the sms
   # Exclude 1/11 and 2/11 because they're management links
   # TODO: This could be tightned up to look just for the first 8 switch ports?
   /tmp/macs-expect | awk '$1 == "2" {print $5","$2}' |sort |grep -E -vw "1/1|2/1|1/11|2/11">/tmp/switch-macs
   cat /tmp/switch-macs
}

function make_dhcpconf() {
    # Create dhcp config file.
    cat > /etc/dhcpd.conf << EOF
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp*/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#
ddns-update-style none;

default-lease-time 900;
max-lease-time 900;
allow bootp;

option pxe-system-type code 93 = unsigned integer 16;
set pxetype = option pxe-system-type;

subnet 10.2.0.0 netmask 255.255.0.0 {
  range 10.2.1.100 10.2.1.200;
  next-server 10.2.0.1;
}

if pxetype=00:06 or pxetype=00:07 {
  # UEFI
  filename "boot/grub2/x86_64-efi/core.efi";
} else {
  # bios
  filename "boot/grub2/i386-pc/core.0";
}
EOF

}

function setup_pxe_server() {
    # POC - Setup a pxe server for a bare bones sles image.

    zypper install -y dhcp-server tftp expect


    MGMTNET="10.2.0"
    BMCNET="10.4.0"

    # Use grub2 as a netbootloader
    grub2-mknetdir --net-directory=/srv/tftpboot

    # Customize grub.cfg for this node
    grubcfg="/srv/tftpboot/boot/grub2/grub.cfg"
    echo "set timeout=10" > $grubcfg
    echo "menuentry 'SHASTA' {" >> $grubcfg
    echo "  linuxefi vmlinuz15 initrd=initrd15.gz rw console=ttyS0,115200n8  nofb" >> $grubcfg
    echo "  initrdefi initrd15.gz" >> $grubcfg
    echo "}" >> $grubcfg

    # Setup dhcpd to work right
    [ $(grep 'DHCPD_INTERFACE=""' /etc/sysconfig/dhcpd) ] && {
    	sed -i "s/DHCPD_INTERFACE=""/DHCPD_INTERFACE=\"${IFACE}\"/" /etc/sysconfig/dhcpd
    }

    # Make our conf file
    make_dhcpconf

    cp /tmp/vmlinuz15 /srv/tftpboot/
    cp /tmp/initrd15.gz /srv/tftpboot/
    chmod 777 /srv/tftpboot/vmlinuz15 /srv/tftpboot/initrd15.gz

    # Flush the arp tables before starting dhcp server
    ip -s -s neigh flush || true
    ip -s -s neigh flush || true
    systemctl restart dhcpd
    systemctl start tftp.socket
    systemctl start tftp.service
}

function establish_ssh() {
    # ssh out to systems with an active lease
    # Creates /tmp/alive with list of ip's that are booted/discovered nodes.
    [ -e /tmp/active ] && rm -rf /tmp/active
    [ -e /tmp/alive ] && rm -rf /tmp/alive
    # Get active leases. may not all be up
    grep ^lease /var/lib/dhcp/db/dhcpd.leases |sort -u |awk '{print $2}' >/tmp/active

    # Not all active leases are live systems. See if we can ssh using our key.
    for i in $(cat /tmp/active)
    do
        # This will be very very slow beyond a few systems
        # TODO Parallelize
        ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o BatchMode=yes root@"$i" "uname -r" >/dev/null 2>&1 && echo $i >>/tmp/alive || continue
    done
}

################################################################################
# Main
################################################################################
create_boot_image # Build discovery image for booting computes

setup_pxe_server
echo ""
echo ""
echo ""
echo "Discovery PXE server setup OK."
sleep 5
echo ""
echo ""
echo "!! POWER ON/CYCLE ALL NODES NOW. !!"
echo ""
echo ""
echo "!! Wait a few minutes for nodes to boot. !!"
echo "Press ENTER To continue"
read foo

# Query switch to get mac addresses
get_macs

foo="N"
while [ "$foo" != "Y" -a "$foo" != "y" ];
do
    clear
    # TODO - check that we have 8 . For preview systems.
    get_macs
    echo ""
    echo "The above mac addresses were found on Vlan2."
    echo "If nodes didn't boot try powercycling the nodes now and re-scan."
    echo "Press \"Y\" or \"y\"to continue,  Any other key to re-scan."
    read foo
done

# Establishing ssh

foo="N"
while [ "$foo" != "Y" -a "$foo" != "y" ];
do
    clear
    # TODO - check that we have 7 . For preview systems.
    echo "Establishing ssh to all nodes... be patient."
    establish_ssh
    touch /tmp/alive
    UP=$(wc -l /tmp/alive)
    echo "The following $UP ip's are responding."
    echo "!!! For a preview system you should have 7 !!!"
    echo "!!! If 7 nodes are not responding please troubleshoot non-booted nodes. !!!"
    echo "!!! If all 7 nodes are powered up, this may take 5 to 10 minutes for all nodes to boot.!!!"
    echo ""
    cat /tmp/alive
    echo ""
    echo "Press \"Y\" or \"y\" to continue,  Any other key to try ssh again."
    read foo
done

# Put all the ip's/macs in a file
for i in $(cat /tmp/alive); do printf $i; ssh -o StrictHostKeyChecking=no root@$i "ip a s eth0 |grep "link/ether""; done |awk '{print $1" "$3}' >/tmp/ipmac

# Now we need to match the switch on the port to a mac address to setup the proper ipmi.
while read macs
do
    tmpip=$(echo "$macs"|cut -f1 -d" ")
    mac=$(echo "$macs"|cut -f2 -d" ")
    # find mac in switch
    bmcipnum=$(grep "$mac" /tmp/switch-macs |cut -f2 -d/ |cut -f1 -d,)
    echo "Setting bmc ip based on switch position."
    echo "$tmpip" "->" 10.4.0."$bmcipnum"

    # Now we ssh to the system and setup bmc3 with the mac on vlan4
    # This is ugly and slow, maybe use -S?
    ssh -o StrictHostKeyChecking=no root@"$tmpip" "ipmitool -C 17 lan set 3 ipsrc static" </dev/null
    ssh -o StrictHostKeyChecking=no root@"$tmpip" "ipmitool -C 17 lan set 3 ipaddr 10.4.0.${bmcipnum}" </dev/null
    ssh -o StrictHostKeyChecking=no root@"$tmpip" "ipmitool -C 17 lan set 3 netmask 255.255.0.0" </dev/null
    ssh -o StrictHostKeyChecking=no root@"$tmpip" "ipmitool -C 17 lan set 3 defgw ipaddr 10.4.0.1" </dev/null
    # Setup root user
    ssh -o StrictHostKeyChecking=no root@"$tmpip" "ipmitool -C 17 user set name 3 root" </dev/null
    ssh -o StrictHostKeyChecking=no root@"$tmpip" "ipmitool -C 17 user set password 3 initial0" </dev/null
    ssh -o StrictHostKeyChecking=no root@"$tmpip" "ipmitool -C 17 channel setaccess 3 3 link=on ipmi=on callin=on privilege=4" </dev/null
    ssh -o StrictHostKeyChecking=no root@"$tmpip" "ipmitool -C 17 user enable 3" </dev/null

    sleep 2 # Wait for bmc to come up
    # Check that we get ipmi reply
    ipmitool -U root -P initial0 -I lanplus -C 17 -H 10.4.0."$bmcipnum" chassis power status
    echo "OK node port $bmcipnum is responding to ipmicommands."
    echo ""
done </tmp/ipmac

 rm -rf /tmp/ipmac
 rm -rf /tmp/alive

 # TODO setup /etc/cray-macs
cut -f2 -d, /tmp/switch-macs > /tmp/sorted-macs
cat > /tmp/nodes << EOF
sms02-nmn
sms03-nmn
sms04-nmn
nid000001-nmn
nid000002-nmn
nid000003-nmn
nid000004-nmn
EOF
paste -d" " /tmp/nodes /tmp/sorted-macs > /etc/cray-macs
echo "!! /etc/cray-macs created to use with the dhcp server during installation of SMS[2-4]. !!"
echo "BACKUP THIS FILE"
cat /etc/cray-macs
echo "Please continue the installation with 'crayctl install' at this time"
