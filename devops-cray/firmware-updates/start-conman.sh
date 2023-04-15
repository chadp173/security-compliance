#!/usr/bin/env bash
set -x
cd /root/k8s; kubectl apply -f cray_conman.yaml
