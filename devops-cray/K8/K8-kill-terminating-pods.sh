#!/usr/bin/env bash
set -x

STATUS=$1

for p in $(kubectl get pods | grep ${STATUS} | awk '{print $1}'); do kubectl delete pods $p --grace-period=0 --force;done
