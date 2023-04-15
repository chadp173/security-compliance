#!/usr/bin/env bash

function die {
    local msg="$1"
    (>&2 echo "Fatal: $msg")  # Subshell avoids interactions with other redirections
    exit 1
}

sudo yum  update -y || {
  die "yum update failed"
}

# Install package dependencies
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2  || die {
  "dependencies installation failed"
}

# Stable repository
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo || die {
    "stable repository failed"
}

# Install Docker
sudo yum install docker-ce docker-ce-cli containerd.io || die {
"install docker-ce failed"
}

sudo docker run docker/whalesay cowsay boo|| die {
"docker has failed cowsay boo"
}

# Add local user to docker group
sudo usermod -aG docker $USER
