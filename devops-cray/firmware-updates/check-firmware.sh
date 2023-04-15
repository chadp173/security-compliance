#!/usr/bin/env bash
set -x

IP_ADDRESS=$1

SDPTool ${IP_ADDRESS} root initial0 systeminfo
