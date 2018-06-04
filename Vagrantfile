# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.provider :virtualbox do |virtualbox, override|
    override.vm.box = "centos/7"
  end

  config.vm.provider :lxc do |lxc, override|
    override.vm.box = "visibilityspots/centos-7.x-minimal"
  end

  config.vm.hostname = "nomad"
  config.vm.synced_folder "nomad", "/opt/nomad", type: "rsync", rsync__chown: false
  config.vm.synced_folder "prometheus", "/opt/prometheus", type: "rsync", rsync__chown: false
  config.vm.provision "shell", path: "initialize.sh"
  config.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true
  config.vm.network "forwarded_port", guest: 9090, host: 9090

  config.vm.provider "docker" do |d|
    d.ports = ["9090:9090"]
  end
end
