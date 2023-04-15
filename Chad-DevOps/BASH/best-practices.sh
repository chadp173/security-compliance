#!/usr/bin/env bash

#!/usr/bin/env bash
# set -x

# read environment variables
BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=$BIN_DIR/../


## Functions
## =========

#----------------------------------------------------------------------------------------------
check_status()
{
        result=$?
        if [ ${result} -ne 0 ] ; then
                echo -e "\e[01;31m[ERROR] $@ \e[00m"
                exit 1;
        fi
}

#----------------------------------------------------------------------------------------------
print_usage() {

  echo "

  Usage:

  $0 -c <container name>
  $0 -r

Options:

    -c
        Redeploy single container.
    -r
        Redeploy CIOCSSP containers (destroy and create).
    -w
        Use updated keystone container(s) when deploying (local only).
Examples:

  $0 -r                                 #Redeploy local BlueFringe service with local DB.
  $0 -c fringe_svc -r                   #Redeploy single container.

" >&2
}