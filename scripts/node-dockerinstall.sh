#!/usr/bin/env bash

# Added this function to make the individual actions prompts readable
. /vagrant/scripts/color.sh

logger "yellow" "*** Install Docker"
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
sudo yum install -y docker-engine
sudo service docker start

sudo groupadd docker
sudo usermod -aG docker vagrant
sudo chkconfig docker on
