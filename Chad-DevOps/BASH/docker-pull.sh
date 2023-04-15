#!/usr/bin/env bash
set -x
REPO=$1
Dockerfile=$2
IMAGE_TAG=$3

docker login bluefringe-docker-local.artifactory.swg-devops.com
docker pull bluefringe-docker-local.artifactory.swg-devops.com/${REPO}/${Dockerfile}
docker images | grep ${Dockerfile}
sleep 30s
docker tag pull bluefringe-docker-local.artifactory.swg-devops.com/${REPO}/${Dockerfile}  bluefringe-docker-local.artifactory.swg-devops.com/${REPO}/${IMAGE_TAG}