#!/usr/bin/env bash


# Added this function to make the individual actions prompts readable
. /vagrant/scripts/color.sh


logger "yellow" "*** Custom OS settings"
sudo apt-get -y update

logger "blue" "*** Set EMC Internal certificate trust"
sudo chmod 666 /etc/ssl/certs/ca-certificates.crt 
sudo cat /vagrant/misc/certs/EMC-SSL.cer /vagrant/misc/certs/EMC-CA.pem.cer >>  /etc/ssl/certs/ca-certificates.crt 

sudo apt-get -y install openjdk-7-jre 
sudo apt-get -y install curl
sudo apt-get -y install genisoimage
sudo apt-get -y install vim
