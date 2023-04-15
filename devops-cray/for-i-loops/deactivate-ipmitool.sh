#!/usr/bin/env bash 

for x in {5..12}; do ipmitool -U root -P initial0 -I lanplus -H 10.4.0.$x -C 17 sol deactivate;done
