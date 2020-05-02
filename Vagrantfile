# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # master server
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.box = "centos/7"
    kmaster.vm.hostname = "kmaster"
    kmaster.vm.box_url = "centos/7"
    kmaster.vm.network :private_network, ip: "192.168.100.10"
    kmaster.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--name", "kmaster"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
    end
    config.vm.provision "shell", inline: <<-SHELL
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config    
      /usr/bin/systemctl reload sshd
    SHELL
    kmaster.vm.provision "shell", path: "./scripts/install_common.sh"
    kmaster.vm.provision "shell", path: "./scripts/install_master.sh"
  end

  numberSrv=2
  # slave server
  (1..numberSrv).each do |i|
    config.vm.define "knode#{i}" do |knode|
    # In the node 
      knode.vm.box = "centos/7"
      knode.vm.hostname = "knode#{i}"
      knode.vm.network "private_network", ip: "192.168.100.1#{i}"
      knode.vm.provider "virtualbox" do |v|
        v.name = "knode#{i}"
        v.memory = 1024
        v.cpus = 1
      end
      config.vm.provision "shell", inline: <<-SHELL
        sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config    
        /usr/bin/systemctl reload sshd
      SHELL
      knode.vm.provision "shell", path: "./scripts/install_common.sh"
      knode.vm.provision "shell", path: "./scripts/install_worker.sh"
    end
  end
end



# vagrant global-status list configs
# vagrant up 
# vagrant ssh kmaster
# vagrant halt 
