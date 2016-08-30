#!/bin/bash


# Added this function to make the individual actions prompts readable
. /vagrant/scripts/color.sh

logger "yellow" "*** Commencing the import of images"

logger "blue" "*** populate TFTP repo"
sudo mkdir -p /var/renasar/on-tftp/static/tftp
cd /var/renasar/on-tftp/static/tftp

for file in $(echo "\
monorail-undionly.kpxe \
monorail.ipxe \
monorail-efi64-snponly.efi \
monorail-efi32-snponly.efi");do
sudo wget "https://dl.bintray.com/rackhd/binary/ipxe/$file"  > /dev/null 2>&1
done

for file in $(echo "\
undionly.kkpxe");do
sudo wget "https://dl.bintray.com/rackhd/binary/syslinux/$file"  > /dev/null 2>&1
done

sudo chmod 755 *


logger "blue" "*** populate HTTP repo"
sudo mkdir -p /var/renasar/on-http/static/http/common
cd /var/renasar/on-http/static/http/common

for file in $(echo "\
base.trusty.3.13.0-32-generic.squashfs.img \
base.trusty.3.16.0-25-generic.squashfs.img \
discovery.overlay.cpio.gz \
initrd.img-3.13.0-32-generic \
initrd.img-3.16.0-25-generic \
vmlinuz-3.13.0-32-generic \
vmlinuz-3.16.0-25-generic");do
sudo wget "https://dl.bintray.com/rackhd/binary/builds/$file"  > /dev/null 2>&1
done

sudo chmod 755 *

logger "blue" "*** Unpack OS build images"
# Unpack the OS Images
if [ ! -f /vagrant/misc/images/CentOS-7-x86_64-*.iso ]; then
   logger "red" "*** no OS CentOS image found to unpack"
else
   sudo python /var/renasar/on-tools/scripts/setup_iso.py /vagrant/misc/images/CentOS-7-x86_64-*.iso /var/mirrors --link=/var/renasar > /dev/null 2>&1
fi
if [ ! -f /vagrant/misc/images/VMware-VMvisor-Installer-6.0.0*.iso ]; then
   logger "red" "*** no OS ESXi image found to unpack"
else
   sudo python /var/renasar/on-tools/scripts/setup_iso.py /vagrant/misc/images/VMware-VMvisor-Installer-6.0.0*.iso /var/mirrors --link=/var/renasar > /dev/null 2>&1
fi

logger "blue" "*** Importing Graphs and SKUs into RackHD"
# Import SKUs and Graphs
# Import CentOS content
curl -H "Content-Type: application/json" -X PUT --data @/vagrant/misc/graphs/noop-centos-install.json http://localhost:8080/api/1.1/workflows
curl -H "Content-Type: application/json" -X POST --data @/vagrant/misc/skus/sku-vbox-centos.json http://localhost:8080/api/1.1/skus
#curl -H "Content-Type: application/json" -X POST --data @/vagrant/misc/skus/sku-vsphere-centos.json http://localhost:8080/api/1.1/skus

# Import ESXi content 
curl -H "Content-Type: application/json" -X PUT --data @/vagrant/misc/graphs/noop-esxi-install.json http://localhost:8080/api/1.1/workflows
curl -H "Content-Type: application/json" -X POST --data @/vagrant/misc/skus/sku-vbox-esxi.json http://localhost:8080/api/1.1/skus
#curl -H "Content-Type: application/json" -X POST --data @/vagrant/misc/skus/sku-vsphere-esxi.json http://localhost:8080/api/1.1/skus
#curl -H "Content-Type: application/json" -X PUT --data @noop-esxi-install-custom.json http://rackhd01.home.local:8080/api/1.1/workflows
#curl -H "Content-Type: application/json" -X PUT --data @noop-esxi-install-custom.json http://localhost:9090/api/1.1/workflows
