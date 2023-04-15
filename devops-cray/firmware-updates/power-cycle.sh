#!/usr/bin/env bash

IP=$1
ipmitool -U root -P initial0 -I lanplus -H ${IP} -C 17 mc reset cold

sleep 3

ipmitool -U root -P initial0 -I lanplus -H ${IP} -C 17 chassis power status
