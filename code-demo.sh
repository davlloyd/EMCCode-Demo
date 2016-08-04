#!/bin/bash

# Set how many test VMs to create 
VM_COUNT=10

asksure() {
   echo "Are you sure (Y/N)? "
   while read -r -n 1 -s answer; do
     if [[ $answer = [YyNn] ]]; then
        [[ $answer = [Yy] ]] && retval=0
        [[ $answer = [Nn] ]] && retval=1
        break
     fi
   done

   return $retval
}

valid=0;
while [[  $valid -lt 1 ]]; do
   clear
   echo "1)    RackHD Only"
   echo "2)    Mesos Only"
   echo "3)    Mesos + Slave Node"
   echo "4)    RackHD + Mesos + Slave Node"
   #echo "5)    RackHD + Mesos + Slave Node + ScaleiO"
   echo "Give us a number (1-4)"
   read -n 1 -s;
   case "${REPLY}" in
       1)
          echo "You chose to install RackHD only"
          if asksure; then
             vagrant up rackhd
             valid=1
          fi
          ;;
       2)
          echo "You chose to install Mesos only"
          if asksure; then
             vagrant up mesos
             valid=2
          fi
          ;;
       3)
          echo "You chose to install Mesos + Slave node"
          if asksure; then
             vagrant up mesos,slave1
             valid=3
          fi
          ;;
       4)
          echo "You chose to install RackHD + Mesos + Slave node"
          if asksure; then
             vagrant up rackhd,mesos,slave1
             valid=4
          fi
          ;;
       5)
          # this one is a work in progress
          echo "You chose to install the lot, you must have a big laptop!"
          if asksure; then
             vagrant up rackhd,mesos,slave1
             valid=5
          fi
          ;;
   esac 
done


### Setup virtual machines to test with RackHD
if [ $valid -eq 1 ] || [ $valid -gt 3 ]
then
   for (( i=1; i <= $VM_COUNT; i++ ))
   do
      vmName="test-$i"
      if [[ ! -e $vmName.vdi ]]; then
          echo "deploying vm: $i"
          VBoxManage createvm --name $vmName --register;
          VBoxManage createhd --filename $vmName --size 8192;
          VBoxManage storagectl $vmName --name "SATA Controller" --add sata --controller IntelAHCI
          VBoxManage storageattach $vmName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $vmName.vdi
          VBoxManage modifyvm $vmName --ostype Linux_64 --boot1 net --memory 1024;
          VBoxManage modifyvm $vmName --nic1 intnet --intnet1 closednet --nicpromisc1 allow-all;
          VBoxManage modifyvm $vmName --nictype1 82543GC --macaddress1 auto;
          VBoxManage modifyvm $vmName --nic2 NAT;
          VBoxManage modifyvm $vmName --nictype2 82543GC --macaddress2 auto;
          VBoxManage modifyvm $vmName --natpf2 "guestssh,tcp,,2$i2$i,,22";
          VBoxManage modifyvm $vmName --ioapic off;
          VBoxManage modifyvm $vmName --rtcuseutc on;          
      fi
   done
fi

