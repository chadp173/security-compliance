#!/bin/bash
set -x

IMAGE=$1
TAG=$2
DIR=$HOME/src/NetEngTools/core-deploy-tools/containers/${IMAGE}/config
cd $HOME/src/NetEngTools/core-deploy-tools/containers/${IMAGE}/config

docker build -t bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/${IMAGE}:${TAG} .
docker push bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/${IMAGE}:${TAG}
sleep 3m

docker tag bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/${IMAGE}:${TAG} us.icr.io/bluefringe/${IMAGE}:${TAG}
docker images | grep ${TAG} | grep ${IMAGE} | grep icr
sleep 1m
docker push us.icr.io/bluefringe/${IMAGE}:${TAG}
sleep 5m
ibmcloud cr images| grep ${TAG} | grep ${IMAGE} 
