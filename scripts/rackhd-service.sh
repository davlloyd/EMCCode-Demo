#!/usr/bin/env bash

# Added this function to make the individual actions prompts readable
. /vagrant/scripts/color.sh

logger "yellow" "Install RackHD Demo Environment Commencing"

logger "blue" "install dependant services"
sudo apt-get -y install rabbitmq-server
sudo apt-get -y install mongodb
sudo apt-get -y install snmp
sudo apt-get -y install ipmitool

curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
VERSION=node_4.x
DISTRO="$(lsb_release -s -c)"
echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list

sudo apt-get -y update
sudo apt-get -y install nodejs
sudo apt-get -y install npm

sudo apt-get -y install git
sudo apt-get -y install ansible
sudo apt-get -y install apt-mirror
sudo apt-get -y install amtterm

sudo apt-get -y install isc-dhcp-server

logger "blue" "install RackHD services"
echo "deb https://dl.bintray.com/rackhd/debian trusty main" | sudo tee -a /etc/apt/sources.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
sudo apt-get update


sudo apt-get -y install on-dhcp-proxy on-http on-taskgraph
sudo apt-get -y install on-tftp on-syslog

for service in $(echo "on-dhcp-proxy on-http on-tftp on-syslog on-taskgraph");
do sudo touch /etc/default/$service;
done

logger "blue" "Import configuration files"
sudo cp /vagrant/config/rackhd/dhcpd.conf /etc/dhcp
sudo cp /vagrant/config/rackhd/config.json /opt/monorail

logger "blue" "Import profile and template files"
sudo cp /vagrant/misc/templates/* /var/renasar/on-http/data/templates
sudo cp /vagrant/misc/profiles/* /var/renasar/on-http/data/profiles

logger "blue" "Start services"
sudo service on-http start
sudo service on-dhcp-proxy start
sudo service on-syslog start
sudo service on-taskgraph start
sudo service on-tftp start
sudo service isc-dhcp-server start

logger "blue" "Clone git On-Tools repo to get setup_iso.py"
cd /var/renasar
sudo git clone https://github.com/RackHD/on-tools.git
