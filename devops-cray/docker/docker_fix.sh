#!/usr/bin/env bash
exec > /var/log/docker_fix.log 2>&1
set -x
set -e

if [[ $(pgrep docker | wc -l) = 0 ]]
then
    zypper in -f -y docker && systemctl restart docker
fi

for i in $(kubectl get pods |grep CrashLoopBackOff |awk '{print $1}'); do kubectl delete pod $i; done

