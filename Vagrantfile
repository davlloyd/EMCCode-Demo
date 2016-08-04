######################
# Vagrant File Start #
######################

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # Mesos Server (Master)
    config.vm.define "mesos" do |mesos|
        mesos.vm.box = "bento/centos-7.1"
        mesos.vm.provider "virtualbox" do |m|
            m.memory = 2048
            m.cpus = 2
            m.customize ["modifyvm", :id, "--nicpromisc2", "allow-all", "--ioapic", "on"]
            m.customize ["storagectl", :id, "--name", "SATA Controller", "--portcount", 30, "--hostiocache", "on"]
        end

        # Mesos VM assigned to same network range as RackHD 
        mesos.vm.network "private_network", ip: "172.31.128.222"
        mesos.vm.hostname = "mesos01"
        
        # Forward ports aligned to the mesos, marathon and chronos services
        mesos.vm.network "forwarded_port", guest: 5050, host: 5555
        mesos.vm.network "forwarded_port", guest: 8080, host: 8888
        mesos.vm.network "forwarded_port", guest: 4400, host: 4444
        
        # Post guest installation and customisation of services
        mesos.vm.provision :shell, path: "scripts/mesos-master.sh"

        # Ensure rexray is running
        mesos.vm.provision "shell", inline: <<-SHELL
           sudo rexray service start
          SHELL

     end
     
     # Mesos Server (Slave 1)
     
     config.vm.define "slave1" do |slave1|
        slave1.vm.box = "bento/centos-7.1"
        slave1.vm.provider "virtualbox" do |s|
            s.memory = 1536
            s.cpus = 2
            s.customize ["modifyvm", :id, "--nicpromisc2", "allow-all", "--ioapic", "on"]
            s.customize ["storagectl", :id, "--name", "SATA Controller", "--portcount", 30, "--hostiocache", "on"]
        end

        # Mesos VM assigned to same network range as RackHD 
        slave1.vm.network "private_network", ip: "172.31.128.223"
        slave1.vm.hostname = "mesos02"
        
        # Forward ports aligned to the mesos, marathon and chronos services
        slave1.vm.network "forwarded_port", guest: 5050, host: 5556
        
        # Post guest installation and customisation of services
        slave1.vm.provision :shell, path: "scripts/mesos-slave1.sh"

       # Ensure rexray is running
       slave1.vm.provision "shell", inline: <<-SHELL
          sudo rexray service start
        SHELL
     end

     # RackHD SERVER
     config.vm.define "rackhd" do |rackhd|
        rackhd.vm.box = "bento/ubuntu-14.04"
        #rackhd.vm.box = "rackhd/rackhd"
        rackhd.vm.box_check_update = true

        rackhd.vm.provider "virtualbox" do |v|
            v.memory = 2048
            v.cpus = 2
            v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all", "--ioapic", "on"]
        end
        
        rackhd.vm.network "forwarded_port", guest: 8080, host: 9090
        rackhd.vm.network "forwarded_port", guest: 5672, host: 9091
        rackhd.vm.network "forwarded_port", guest: 9080, host: 9092
        rackhd.vm.network "forwarded_port", guest: 8443, host: 9093


        rackhd.vm.hostname = "rackhd01"
        rackhd.vm.network "private_network", ip: "172.31.128.1", virtualbox__intnet: "closednet"

        rackhd.ssh.forward_agent = true

        # Post guest installation and customisation of core services
        rackhd.vm.provision :shell, path: "scripts/rackhd-os.sh"
        # installation of RackFD (Monorail) services
        rackhd.vm.provision :shell, path: "scripts/rackhd-service.sh"
        # Import of build images, boot files, core graphs and skus
        rackhd.vm.provision :shell, path: "scripts/rackhd-imageimport.sh"
        # Get RackHD running Docker and Docker machine
        rackhd.vm.provision :shell, path: "scripts/rackhd-docker.sh"

     end
end
