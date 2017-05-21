# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = 'ubuntu/xenial64'

  config.vm.define "controller" do |controller|
    controller.vm.hostname = "controller"
    controller.vm.network "forwarded_port", guest: 80, host: 8080
    controller.vm.synced_folder ".", "/vagrant/production", type: "rsync", rsync__exclude: [".git/", ".bundle/"]
    controller.vm.network :private_network, ip: "192.168.0.10"
  
    controller.vm.provision "shell", path: "bin/prov.sh"
  
    controller.vm.provider "virtualbox" do |vb|
    #
    #   # Customize the amount of memory on the VM:
      vb.memory = "8192"
      vb.customize ["modifyvm", :id, "--cpus", "4" ]
      vb.customize ["modifyvm", :id, "--ioapic", "on" ]
      vb.customize ["modifyvm", :id, "--natdnspassdomain1", "off"]
    end
  end

  config.vm.define "compute01" do |compute01|
    compute01.vm.hostname = "compute01"
    compute01.vm.synced_folder ".", "/vagrant/production", type: "rsync", rsync__exclude: [".git/", ".bundle/"]
    compute01.vm.network :private_network, ip: "192.168.0.20"

    compute01.vm.provision "shell", path: "bin/prov.sh"

    compute01.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.customize ["modifyvm", :id, "--cpus", "2" ]
      vb.customize ["modifyvm", :id, "--ioapic", "on" ]
      vb.customize ["modifyvm", :id, "--natdnspassdomain1", "off"]
    end
  end
end
