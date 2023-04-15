#!/usr/bin/env bash

DIR="$HOME/src/NetEngTools/ciocssp-core"
GIT="git pull"
CMD="prepare_deployment.sh"
JAVA="bin/dev_gui"

cd ${DIR} && ${GIT}
sh ${DIR}/${CMD}
sleep 5m 
sh ${DIR}/${JAVA} 


