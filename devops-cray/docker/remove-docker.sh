#!/bin/bash 

IMAGE=$1

docker rmi -f ${IMAGE} 
