# Dockerfile for Twistlock 

ARG FROM_IMAGE=docker-na.artifactory.swg-devops.com/bluefringe-docker-local/net-eng-tools/base_phusion_nojava

ARG FROM_TAG=20220624 

FROM $FROM_IMAGE:$FROM_TAG 

MAINTAINER fringe@us.ibm.com 
LABEL Description="Twistlock Container"

#### Install application specific software
RUN apt-get update && apt-get install -y \    
    wget \ 
    unzip \
    original-awk \
    coreutils \
    curl \
    file \
    grep \
    gzip \
    jq \
    sed \
    tar \
    uuid-runtime

#### Installation of Software
RUN /bin/curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
RUN /bin/wget --no-check-certificate  https://w3twistlock.sos.ibm.com/download/tt_v1.4.0/tt_v1.4.0.zip -P /tmp
RUN /bin/unzip /tmp/tt_v1.4.0.zip
RUN /bin/chmod +x /tt_v1.4.0/linux_x86_64/tt

# Transfer the BlueFringe Fringe
COPY files/bf_local_build.sh /tmp
RUN  /bin/chmod 755 /tmp/bf_local_build.sh

# Transfer the AAA Fringe
COPY files/aaa_local_build.sh /tmp
RUN  /bin/chmod 755 /tmp/aaa_local_build.sh

# Transfer the Edge Compute
COPY files/ecn_local_build.sh /tmp
RUN  /bin/chmod 755 /tmp/ecn_local_build.sh

#### Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/*  /var/tmp/*

CMD ["/sbin/my_init"]

