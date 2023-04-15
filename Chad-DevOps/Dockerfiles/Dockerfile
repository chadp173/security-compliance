FROM ubuntu:18.04

## Install application specific software
RUN apt-get install --yes \
python-software-properties \

## Enable OpenStack repositories
RUN apt-get update -y  \
	&& add-apt-repository cloud-archive:rocky \
	&& apt-get update -y

## Install application specific software
RUN export DEBIAN_FRONTEND=noninteractive \
        && apt-get install --yes \
	apache2 \
	keystone \
	keystone-doc \
	mysql-server \
	memcached \
	python3-openstackclient \
	libapache2-mod-wsgi-py3 \
	libapache2-mod-auth-openidc \
	python-pymysql \
	rabbitmq-server

## Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
