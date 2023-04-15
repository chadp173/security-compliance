#!/usr/bin/env bash
set -x

for x in {1..4};do ipmitool -U root -P initial0 -I lanplus -H 10.4.0.$x -C 17 lan set 1 cipher_privs XXaXXXXXXXaXXXX; echo $x; done
for x in {1..4};do ipmitool -U root -P initial0 -I lanplus -H 10.4.0.$x -C 17 lan set 2 cipher_privs XXaXXXXXXXaXXXX; echo $x; done
for x in {1..4};do ipmitool -U root -P initial0 -I lanplus -H 10.4.0.$x -C 17 lan set 3 cipher_privs XXaXXXXXXXaXXXX; echo $x; done
