#!/usr/bin/env bash
set -x
CONTAINER=$1
COMMAND=$2

docker exec -it ${CONTAINER} bash -c ${COMMAND}
