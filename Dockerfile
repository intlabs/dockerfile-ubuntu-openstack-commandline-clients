#
# Ubuntu Desktop (Gnome) Dockerfile
#
# https://github.com/intlabs/dockerfile-ubuntu-openstack-commandline-clients
#

# Install GNOME3 and VNC server.
# (c) Pete Birley

# Pull base image.
FROM dockerfile/ubuntu

# Setup enviroment variables
ENV DEBIAN_FRONTEND noninteractive

#Update the package manager and upgrade the system
RUN apt-get update && \
apt-get upgrade -y && \
apt-get update

# Upstart and DBus have issues inside docker.
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

#Install ssh server
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd 

#Create user
RUN adduser --disabled-password --gecos "" user
RUN echo 'user:acoman' |chpasswd

#you can ssh into this container ssh user@<host> -p <whatever 22 has been mapped to>

#Install the openstack command line tools
RUN apt-get install -y python-ceilometerclient
RUN apt-get install -y python-cinderclient
RUN apt-get install -y python-glanceclient
RUN apt-get install -y python-heatclient
RUN apt-get install -y python-keystoneclient
RUN apt-get install -y python-neutronclient
RUN apt-get install -y python-novaclient
RUN apt-get install -y python-swiftclient
#RUN apt-get install -y python-troveclient

ADD startup.sh /usr/local/etc/startup.sh
RUN chmod +x /usr/local/etc/startup.sh

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD bash -C '/usr/local/etc/startup.sh';'bash'
#CMD "bash"

# Expose ports.
EXPOSE 22