# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'rbconfig'

Vagrant.require_version ">= 1.9.0"

$num_controllers = 1
$num_workers = (ENV['WORKERS'] || 0).to_i
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
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/ — timesync-set-threshold", 10000]
  end

  config.vm.define "control" do |controller|
    controller.vm.hostname = "control"
    ip = "#{$subnet}.100"
    controller.vm.network "private_network", ip: ip
    controller.vm.provision "shell", path: "scripts/_configure.sh", args:[$num_workers, $subnet]
    controller.vm.provision "shell", path: "scripts/_kube_install.sh"
    controller.vm.provision "shell", privileged: false, path: "scripts/_kube-init.sh", args:[$temp]
  end

  (1..$num_workers).each do |n|
    name = "node#{'%02d' % n}"
    config.vm.define name do |node|
      node.vm.hostname = name
      ip = "#{$subnet}.#{n+100}"
      node.vm.network "private_network", ip: ip
      node.vm.provision "shell", path: "scripts/_configure.sh", args:[$num_workers, $subnet]
      node.vm.provision "shell", path: "scripts/_kube_install.sh"
      node.vm.provision "shell", path: "#{$temp}/join.sh"
      node.vm.provision "shell", inline: "sysctl net.bridge.bridge-nf-call-iptables=1"
    end
  end

end
