!#/urs/bin/env bash

set -x

for p in {1..12}; do ipmitool -I lanplus -U root -P initial0 -H nid0000$p chassis power cycle; done
