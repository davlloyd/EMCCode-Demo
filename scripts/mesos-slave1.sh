#!/usr/bin/env bash


# Added this function to make the individual actions prompts readable
. /vagrant/scripts/color.sh


logger "yellow" "*** Set EMC Internal certificate trust"
sudo chmod 666 /etc/pki/tls/certs/ca-bundle.crt 
sudo cat /vagrant/misc/certs/EMC-SSL.cer /vagrant/misc/certs/EMC-CA.pem.cer >> /etc/pki/tls/certs/ca-bundle.crt 

logger "yellow" "*** Install Mesos and Marathon"
sudo echo "172.31.128.223 mesos02 mesos02.demo.local" >> /etc/hosts
#sudo rpm -Uvh http://repos.mesosphere.io/el/6/noarch/RPMS/mesosphere-el-repo-6-2.noarch.rpm
sudo rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
sudo yum -y install mesos

. /vagrant/scripts/node-rexrayinstall.sh

. /vagrant/scripts/node-installdocker.sh

logger "yellow" "*** Enable Docker in Mesos"
echo 'docker,mesos' | sudo tee /etc/mesos-slave/containerizers
sudo service mesos-slave restart


logger "yellow" "*** Install Mesos Driver DVDi"
curl -sSL https://dl.bintray.com/emccode/dvdcli/install | sh -
get -nv --directory-prefix=/usr/lib https://github.com/emccode/mesos-module-dvdi/releases/download/v0.1.0/libmesos_dvdi_isolator-0.23.0.so
cp /vagrant/config/dvdi/dvdi-mod.json /usr/lib
cp /vagrant/config/dvdi/modules /etc/mesos-slave

logger "yellow" "*** Install Scaleio client""
# To install the SDC you need to also get the scaleio RHEL7 source expanded
#sudo MDM_IP=172.31.128.202,172.31.128.203 rpm -Uv /vagrant/scaleio/scaleio/ScaleIO_2.0.0_RHEL7_Download/EMC-ScaleIO-sdc-2.0-5014.0.el7.x86_64.rpm 
