#!/usr/bin/env bash

FILE=pod.yaml
read $FILE

kubectl delete -f ${FILE} --grace-period=0 --force ; kubectl apply -f ${FILE}
