#!/usr/bin/env bash
# set -x

# Remove dangling images
docker rmi -f $(docker images -f "dangling=true" -q)
sh  /Users/chad.perry1/Desktop/cperry-devops/cperry-ibm-sre-v1.0/devops-cray/docker/docker-clean-2.0.sh
#################################################################
# New Employee Setup BF Local Environment                       #
# This is used only when you build a new verion from scratch    #
#################################################################

###############################################################################
# docker login https://bluefringe-docker-local.artifactory.swg-devops.com
# cd $HOME/src/NetEngTools/ciocssp-frontend
# sh ~/src/NetEngTools/ciocssp-frontend/prepare_deployment.sh -c
# sh ~/src/NetEngTools/ciocssp-frontend/prepare_deployment
# sleep 2m
################################################################################
#DIR_1="/Users/chad.perry1/src/NetEngTools/ciocssp-core"
DIR_2="/Users/chad.perry1/src/NetEngTools/core-deploy-tools/bin"
#RUN_CMD1="prepare_deployment.sh"
RUN_CMD2="deploy_ciocssp_attempt.sh -r"
#LOGIN="docker login https://bluefringe-docker-local.artifactory.swg-devops.com"
GIT_PULL="git pull"

#${LOGIN}

# Pulling the latest code from BF
#echo "preparing environment"
#cd ${DIR_1} &&  ${GIT_PULL}
#sh ${RUN_CMD1}
#sleep 2m

#echo "setting up BF"
cd ${DIR_2} && ${GIT_PULL}
sh ${DIR_2}/${RUN_CMD2}

# Smoke to Verify that BF is working correctly
#sh /Users/chad.perry1/src/NetEngTools/core-deploy-tools/bin/test_smoke.sh
#sleep 3m

echo "https://devlocal-portal.fringe.ibm.com/"
cd /Users/chad.perry1/src/NetEngTools/ciocssp-core
