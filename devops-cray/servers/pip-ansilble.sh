#!/usr/bin/env bash

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sleep 2m
chmod +x get-pip.py
python get-pip.py
sleep 2m

pip install ansible
