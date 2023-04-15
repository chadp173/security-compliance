#!/usr/bin/env bash

#########################################
###           Install docker          ###
#########################################

# Install needed packages
sudo yum install python-pip -y
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Configure Docker repo
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker CE
sudo yum install -y docker-ce

# Add user to docker group
sudo usermod -aG docker $(whoami)

## Create /etc/docker directory.
sudo mkdir -p /etc/docker

# Setup daemon.
sudo cat > /etc/docker/daemon.json <<EOM
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOM

mkdir -p /etc/systemd/system/docker.service.d

# Systemd to enable/start Docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
docker version

# Install needed packages
sudo yum install -y epel-release

# Install pip
sudo pip install --upgrade pip


# Upgrade python
sudo yum upgrade -y python*
docker-compose version

#########################################
###      Install Ansible              ###
#########################################

# Install Ansible
sudo yum install -y ansible

#########################################
###      Install kubernetes           ###
#########################################
# Install K8

sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
