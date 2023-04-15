#!/usr/bin/env bash 

BRANCH=$1
MESSAGE=$2

git checkout  -b ${BRANCH}
git add . 
git commit -m "${MESSAGE}"
git push git@github.ibm.com:Chad-Perry1/wiki-pages.git
git log
