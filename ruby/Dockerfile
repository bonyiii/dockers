# Don't forget to specify to exact version not to latest ;)
FROM phusion/baseimage:latest
MAINTAINER Boni <boni@twine.hu>

RUN apt-get -qq update
RUN apt-get install -y vim
RUN apt-get install -y build-essential
RUN apt-get install -y openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev sqlite3 autoconf libc6-dev ncurses-dev automake libtool pkg-config
RUN apt-get install -y git npm
#RUN apt-get install -y postgresql-client postgresql-server-dev-9.4 memcached

# Set root user password
RUN echo 'root:password' | chpasswd

# Create user the app will run as this user
RUN useradd -p password --shell /bin/bash --create-home --home-dir=/home/myapp_user myapp_user

# Add user to sudoers for rvm to be able install needed system packages
# Later user may removed from sudoers
RUN echo 'myapp_user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Adding Gemfiles and path gems
# https://blog.abevoelker.com/rails-development-using-docker-and-vagrant/
RUN mkdir -p /home/myapp_user/myapp

# System wide installations finished (except that rvm will make with sudo)
# Switch to the user whose name the app will be run
USER myapp_user

# Switch to the working directory
RUN cd /home/myapp_user
ENV HOME /home/myapp_user

# Make git not asking to accept ssh key
#RUN echo "Host bitbucket.org\n\tStrictHostKeyChecking no\n" >> /home/dev/.ssh/config

# Installing rvm and bundler locally for myapp_user
# load rvm and other settinge into the shell
RUN /bin/bash -l -c "source /home/myapp_user/.bashrc"
# Download and accept rvm gpg key
RUN /bin/bash -l -c "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"
# Install rvm
RUN curl -L https://get.rvm.io | bash -s stable
# Only system wide step that requires sudo later sudoers should revoked from user
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.5"
RUN /bin/bash -l -c "rvm use 2.1.5"
RUN /bin/bash -l -c "rvm gemset create myapp"
RUN /bin/bash -l -c "rvm gemset use myapp"

# Switch back to root since runit will be used 
# and it needs root access
USER root

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# SSH login
RUN rm -f /etc/service/sshd/down
# Add ssh public key to authorized key to be able to log in
# id_rsa.pub on host is: ln /home/myapp_user/.ssh/id_rsa.pub
# this way it is the same file by a hard link
ADD id_rsa.pub /tmp/myapp_user_key.pub
RUN cat /tmp/myapp_user_key.pub >> /root/.ssh/authorized_keys && rm -f /tmp/your_key.pub

# Add myapp app server runit start script
RUN mkdir /etc/service/myapp_webrick
ADD service/myapp_webrick.sh /etc/service/myapp_webrick/run

# App will listen on this port
EXPOSE 3000

# Start phusion passanger baseimage init
CMD ["/sbin/my_init"]
