#!/usr/bin/env bash
set -x
set -e
 
# Variable 
DISK=$1
  
mkfs.ext4 -L CRAYBLOB /dev/${DISK}
sleep 3m
 
rsync -avP 172.30.50.19:/var/www/html/dstrepo/shasta-cd-preview4/* /mnt/
