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

# Install Openstack Command Line tools
RUN apt-get install -y python-pip
# These are required to keep some of the pip installs happy
RUN apt-get install -y python-simplejson
RUN apt-get remove -y python-six

#Install the command line tools
RUN pip install python-ceilometerclient
RUN pip install python-cinderclient
RUN pip install python-glanceclient
RUN pip install python-heatclient
RUN pip install python-keystoneclient
RUN pip install python-neutronclient
RUN pip install python-novaclient
RUN pip install python-swiftclient
#RUN pip install python-troveclient


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