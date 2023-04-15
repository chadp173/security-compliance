#!/usr/bin/env bash
set -x
IP=$1

ipmitool -I lanplus -H ${IP} -U root -P initial0 sol deactivate
