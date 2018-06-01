FROM jenkins/jenkins:lts

USER root

# Install Docker and additional packages
RUN apt-get update && \
    apt-get --yes install sudo software-properties-common apt-transport-https vim && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get --yes install docker-ce

# Install Docker Machine
RUN base=https://github.com/docker/machine/releases/download/v0.14.0 && \
    curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine && \
    install /tmp/docker-machine /usr/local/bin/docker-machine

RUN usermod -a -G docker jenkins && \
    echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins