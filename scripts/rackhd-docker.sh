#!/usr/bin/env bash


# Added this function to make the individual actions prompts readable
. /vagrant/scripts/color.sh

logger "blue" "Installing Docker"
sudo su
curl -L https://get.docker.com/builds/Linux/x86_64/docker-1.11.0.tgz > docker-1.11.0.tgz && tar -xf docker-1.11.0.tgz && cp docker/docker /usr/local/bin/docker && chmod +x /usr/local/bin/docker
curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && chmod +x /usr/local/bin/docker-machine

logger "blue" "Installing RackHD Docker-machine driver"
curl -L https://github.com/emccode/docker-machine-rackhd/releases/download/v0.1.0/docker-machine-driver-rackhd.`uname -s`-`uname -m` > /usr/local/bin/docker-machine-driver-rackhd && chmod +x /usr/local/bin/docker-machine-driver-rackhd

