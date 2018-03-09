# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'rbconfig'

Vagrant.require_version ">= 1.9.0"

$num_controllers = 1
$num_nodes = (ENV['NODES'] || 0).to_i
$vm_gui = false
$vm_memory = 1024
$vm_cpus = 1
$subnet = "172.17.8"
$temp = ".tmp"

Dir.mkdir $temp unless File.exists? $temp

Vagrant.configure("2") do |config|
  # always use Vagrants insecure key
  config.ssh.insert_key = false
  config.vm.box = "bento/ubuntu-16.04"
  config.ssh.username = "vagrant"

  config.vm.provider :virtualbox do |vb|
    vb.gui = $vm_gui
    vb.memory = $vm_memory
    vb.cpus = $vm_cpus
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    # Compare the time every 1 seconds.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-interval", "1000"]
    # Only change by 1 second at a time.
    # Changing the time a lot can confuse processes that interrogate the time to do their work.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000]
    # Only change when it is ±0.1s out.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-min-adjust", "50"]
    # Resync time when we restart.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-on-restore", "1"]
    # Set the time when starting the service.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-start"]
  end

  config.vm.define "control" do |controller|
    controller.vm.hostname = "control"
    ip = "#{$subnet}.100"
    controller.vm.network "private_network", ip: ip
    controller.vm.provision "shell", path: "scripts/_configure.sh", args:[$num_nodes, $subnet]
    controller.vm.provision "shell", path: "scripts/_kube_install.sh"
    controller.vm.provision "shell", privileged: false, path: "scripts/_kube-init.sh", args:[$temp]
  end

  (1..$num_nodes).each do |n|
    name = "node#{'%02d' % n}"
    config.vm.define name do |node|
      node.vm.hostname = name
      ip = "#{$subnet}.#{n+100}"
      node.vm.network "private_network", ip: ip
      node.vm.provision "shell", path: "scripts/_configure.sh", args:[$num_nodes, $subnet]
      node.vm.provision "shell", path: "scripts/_kube_install.sh"
      node.vm.provision "shell", path: "#{$temp}/join.sh"
      node.vm.provision "shell", inline: "sysctl net.bridge.bridge-nf-call-iptables=1"
    end
  end

end
