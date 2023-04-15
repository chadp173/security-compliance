#!/usr/bin/env bash
set -x
HOSTNAME=$1

for i in {2...4}; do ssh {HOSTNAME}$i-nmn && "uptime" && ;done
