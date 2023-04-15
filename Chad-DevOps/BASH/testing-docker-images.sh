#!/usr/bin/env bash
exec > /Users/chad.perry1/Desktop/testing.log 2>&1
set -x
set -e

APP=$1
BASE=$2
DTAG=20210301
#DTAG=$(date +"%Y%m%d")

docker history -q bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/${APP}:${DTAG} | grep $(docker image ls -q bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/${BASE}:${DTAG})
