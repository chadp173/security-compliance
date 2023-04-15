#!/usr/bin/env bash
exec > /var/log/mk-mount.log 2>&1
set -x
set -e

# Variables
DISK=$1
NUMBER=$2

# Make the file system
mkfs.ext3 /dev/${DISK}
mkdir /helm-ceph-${NUMBER}

# Create a backup of the fstab
cp /etc/fstab /etc/fstab$(date +%Y%m%d%H%M%S)

# Edit the fstab and mount the drive
echo "/dev/${DISK} 	/helm-ceph-${NUMBER} ext4    defaults0 0" >> /etc/fstab
mount /dev/${DISK} /helm-ceph-${NUMBER}
df -Th > /root/tmp.log 2>&1
lsblk > /root/disk.log 2>&1
