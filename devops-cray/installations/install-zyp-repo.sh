#!/usr/bin/env bash


# Install docker
zypper -f -y install docker
systemctl start docker
systemctl enable docker
docker run hello-world

# Install PIP
zypper install python-pip python pip perl wget git vim
pip install --upgrade pip

# Install Ansible
pip install ansible

# Setup Cray Repos
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Installer-DVD-x86_64-GM-DVD1/ dvd1
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Module-Basesystem/ base
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Module-Containers/ containers
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Module-Desktop-Applications/ desktop
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Module-Development-Tools/ develop
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Module-HPC/ hpc
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Module-Legacy/ legacy
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Module-Live-Patching/ livepatch
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Module-Public-Cloud/ publiccloud
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Module-SAP-Applications/ sap
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Module-Server-Applications/ server
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Product-HA/ ha
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Product-HPC/ hpc1
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Product-SLED/ sled
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Product-SLES/ sles1
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Product-SLES_SAP/ slessap
zypper ar http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Packages-x86_64-GM-DVD1/Product-WE/ we

