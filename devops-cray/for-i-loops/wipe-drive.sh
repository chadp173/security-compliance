#!/usr/bin/env bash 
set -x 

 for i in {a..f};do wipefs --all --force /dev/sd$i;done
