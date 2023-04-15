#!/usr/bin/env bash 
set -x
IMAGE=$1
cd /Users/chad.perry1/src/NetEngTools/core-deploy-tools/containers/${IMAGE}/config
docker build -t bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/${IMAGE}:$TAG . 

