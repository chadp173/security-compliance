#!/usr/bin/env bash
set -x

cd /root/k8s; kubectl delete -f cray_conman.yaml
