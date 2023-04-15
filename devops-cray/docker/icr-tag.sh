#!/usr/bin/env bash 
IMAGE=$1
SOURCE=bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/
DEST=us.icr.io/bluefringe/
set -x

 tag images artifactory -> icr
 docker tag ${SOURCE}${IMAGE}:$TAG ${DEST}${IMAGE}:${TAG} > push-tmp1.txt
 docker images | grep ${IMAGE} | grep ${TAG}

# push image to icr with log file
touch ${PWD}/push.log
docker push ${DEST}${IMAGE}:$TAG > push-tmp2.txt
sleep 3m
ibmcloud cr images | grep ${IMAGE} | grep ${TAG} > ${PWD}/push-tmp3.txt
ibmcloud cr va ${DEST}${IMAGE}:${TAG} > push-tmp4.txt
paste push-tmp*.txt > push.log

