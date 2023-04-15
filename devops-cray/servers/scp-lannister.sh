#!/usr/bin/env bash 
exec > /Users/cperry/Desktop/devops-cray/servers 
set -x 

DIRECTORY=$1

scp -r ${DIRECTORY} cperry@172.26.62.10:/home/cperry

