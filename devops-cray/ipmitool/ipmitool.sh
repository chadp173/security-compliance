#!/usr/bin/env bash
set -x

ipmitool -I lanplus -U root -P initial0 -H ${HOSTNAME} 
