#!/bin/bash

set -x 
set -e 

IMAGE=$1

docker build -t ${IMAGE} .
# sleep 120 
docker images | grep ${IMAGE}

