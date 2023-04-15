#!/usr/bin/env bash
set -x
# Installation of lustre fs
# CentOS 7.3

# epel
rpm -ivh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm

# kernel dev-tools
yum -y groupinstall "Development Tools"
yum -y install automake xmlto asciidoc elfutils-libelf-devel zlib-devel binutils-devel newt-devel python-devel \
 hmaccalc perl-ExtUtils-Embed rpm-build make gcc redhat-rpm-config patchutils git
yum -y install xmlto asciidoc elfutils-libelf-devel zlib-devel binutils-devel newt-devel python-devel \
 hmaccalc perl-ExtUtils-Embed bison elfutils-devel audit-libs-devel
yum -y install pesign numactl-devel pciutils-devel ncurses-devel libselinux-devel xfsprogs dracut linux-firmware
yum -y update && yum -y upgrade

# Preparing the Lustre source
useradd -m build
su build
cd $HOME
git clone git://git.whamcloud.com/fs/lustre-release.git
cd lustre-release
chmod +x autogen
sh ./autogen.sh
