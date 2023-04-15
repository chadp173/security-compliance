#!/usr/bin/env bash
############################################
#                                          #
#    Script: Firmware_installtion.sh       #
#    Author: Chad Perry                    #
#    Date: 05/23/19                        #
#                                          #
############################################

exec > /tmp/firmware_upgrade/install.log 2&1$
set -x

# Variables
IP_ADDRESS=$1

# Debugging Function
function die {
    local msg="$1"
    (>&2 echo "Fatal: $msg")  # Subshell avoids interactions with other redirections
    exit 1
}

# Daemons Required for SDPTool
zypper install -y glibc-32bit libgcc_s1-32bit java-1_8_0-openjdk libstdc++6-32bit || {
  die "installation of Daemons failed"
}

# Installation of SDPTool
mkdir -p /tmp/firmware_upgrade; cd /tmp/firmware_upgrade/
wget https://downloadmirror.intel.com/28652/eng/SDPTool-1.3-6.tar.gz
tar zxvf SDPTool-1.3-6.tar.gz
# cd /tmp/firmware_upgrades/SDPTool-1.3-6/RPMS/sles12_x
rpm -Uvh /tmp/firmware_upgrades/SDPTool-1.3-6/RPMS/sles12_x/SDPTool-1.3-6.x86_64.rpm || {
  die "rpm installation failed"
}
# Copy the firmware from dstutility.us.cray.com
scp -r root@172.30.84.40:/scratch/IntelV16-bios/CS500_S2600BP_EFI_UEFIBoot_BIOSR02010008_ME04.01.04.251_BMC1.93.870cf4f0_FRUSDR_1.39_DCPMM1.2.0.5346.zip root@${IP_ADDRESS}:/tmp/firmware_upgrades || {
  die "secure copy failed"
}

# Disable K8 for cray-conman
cd /root/k8s; kubectl delete -f cray_conman.yaml || {
  die "cray-conman failed drain"
}

sleep 3

echo "Please run the commands need for SDPTool using Parrel"
