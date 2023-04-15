#!/usr/bin/env bash
HOSTNAME=$1
ipmitool -I lanplus -H ${HOSTNAME}-sms-bmc -U root -P initial0 sol activate
