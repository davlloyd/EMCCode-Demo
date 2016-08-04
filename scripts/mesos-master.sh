#!/usr/bin/env bash


# Added this function to make the individual actions prompts readable
. /vagrant/scripts/color.sh

logger "blue" "*** Set EMC Internal certificate trust"
sudo chmod 666 /etc/pki/tls/certs/ca-bundle.crt 
sudo cat /vagrant/misc/certs/EMC-SSL.cer /vagrant/misc/certs/EMC-CA.pem.cer >> /etc/pki/tls/certs/ca-bundle.crt 

logger "yellow" "*** Install Mesos and Marathon"
sudo echo "172.31.128.222 mesos01 mesos01.demo.local" >> /etc/hosts
sudo rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
sudo yum -y install mesos marathon

logger "yellow" "*** Install and configure Zookeeper"
sudo rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm
sudo yum -y install zookeeper zookeeper-server
sudo -u zookeeper zookeeper-server-initialize --myid=1
sudo service zookeeper-server start
sudo chkconfig zookeeper-server on

logger "yellow" "*** kickoff Mesos"
sudo service mesos-master start
sudo service mesos-slave start
sudo service marathon start
export MASTER=$(mesos-resolve `cat /etc/mesos/zk` 2>/dev/null)

logger "yellow" "*** Set Mesos services to auto start"
sudo systemctl enable mesos-master
sudo systemctl enable mesos-slave
sudo systemctl enable marathon



logger "yellow" "*** Install Mesos DNS"
sudo yum -y install golang git bind-utils
if [ ! -f ~/go ]; then
    mkdir ~/go
fi

export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

if [ ! -f $GOPATH/src/github.com/mesosphere/mesos-dns ]; then
    echo Build MesosDNS

    go get github.com/tools/godep
    go get github.com/mesosphere/mesos-dns
    cd $GOPATH/src/github.com/mesosphere/mesos-dns
    godep go build .
    cp /root/go/src/github.com/mesosphere/mesos-dns/config.json.sample /root/go/src/github.com/mesosphere/mesos-dns/config.json
fi

logger "yellow" "*** Start MesosDNS"
sudo root/go/src/github.com/mesosphere/mesos-dns/mesos-dns -v=1 -config=/root/go/src/github.com/mesosphere/mesos-dns/config.json

logger "yellow" "*** Install Chronos"
sudo yum -y install chronos
sudo service chronos start
sudo systemctl enable chronos


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

logger "yellow" "*** Install Scaleio client"
# To install the SDC you need to also get the scaleio RHEL7 source expanded
#sudo MDM_IP=172.31.128.202,172.31.128.203 rpm -Uv /vagrant/scaleio/scaleio/ScaleIO_2.0.0_RHEL7_Download/EMC-ScaleIO-sdc-2.0-5014.0.el7.x86_64.rpm 
