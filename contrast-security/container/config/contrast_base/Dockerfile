# Dockerfile for Phusion base image w/Java8

ARG FROM_IMAGE=bluefringe-docker-local.artifactory.swg-devops.com/net-eng-tools/phusion/baseimage
ARG FROM_TAG=focal-1.1.0

ARG CONTRAST_AGENT_VERSION=3.14.0.26897
ARG CONTRAST__API__API_KEY=vgy5soZn15wnVPHH539pF8F7niofbl4N
ARG CONTRAST__API__SERVICE_KEY=EMODO7ZF2MWAP798
ARG CONTRAST__API__USER_NAME=agent_142bb017-de7e-4af7-b5b9-f0782aa6d369@Ibm
ARG CONTRAST__API__URL=https://app.contrastsecurity.com/Contrast

FROM $FROM_IMAGE:$FROM_TAG

MAINTAINER fringe@us.ibm.com
LABEL Description="Phusion base image w/Java8"

## Install basic software
RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update && apt-get upgrade --yes && apt-get install --yes \
	apt-utils \
	dnsutils \
	iputils-ping \
	lsof \
	man \
	net-tools \
	patch \
	strace \
	telnet \
        curl \
        wget \
	vim

## Remove ssh server, purge so that residual configs are deleted too
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get -y purge openssh-server openssh-sftp-server

#https://github.ibm.com/NetEngTools/Delivery/issues/581
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --yes \
        openjdk-8-jdk \
        software-properties-common \
        -o APT::Install-Suggests=0 -o APT::Install-Recommends=0

RUN wget https://pkg.contrastsecurity.com/go-agent-release/latest/linux-amd64/contrast-go 
 

# ADD https://repo1.maven.org/maven2/com/contrastsecurity/contrast-agent/4.8.0/contrast-agent-4.8.0.jar /opt/contrast/contrast.jar
COPY files/contrast_security.yaml /opt/contrast/contrast_security.yaml

#ENV CONTRAST_OPTS "-javaagent:/opt/contrast/contrast.jar \
#-Dcontrast.config.path=/opt/contrast/contrast_security.yaml"

#ENV JAVA_TOOL_OPTIONS $CONTRAST_OPTS \
#    -Dcontrast.api.url=https://app.contrastsecurity.com/Contrast \
#    -Dcontra-Dcontrast.api.api_key=y5soZn15wnVPHH539pF8F7niofbl4N \
#    -Dcontrast.api.service_key=EMODO7ZF2MWAP798 \
#     -Dcontrast.api.user_name=agent_142bb017-de7e-4af7-b5b9-f0782aa6d369@Ibm

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Remove sshd service
#RUN rm -r /etc/service/sshd && rm /etc/my_init.d/00_regen_ssh_host_keys.sh

#ADD TLS/jssecacerts /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/
#RUN chmod 0644 /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/jssecacerts

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
