# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.box = "centos/7"

  config.vm.provider :virtualbox do |virtualbox, override|
    virtualbox.customize ["modifyvm", :id, "--memory", 2048]
  end

  config.vm.provider :lxc do |lxc, override|
    override.vm.box = "visibilityspots/centos-7.x-minimal"
  end

  config.vm.hostname = "nomad"
  config.vm.synced_folder "nomad", "/opt/nomad", type: "rsync", rsync__chown: false
  config.vm.synced_folder "prometheus", "/opt/prometheus", type: "rsync", rsync__chown: false
  config.vm.provision "shell", path: "initialize.sh"
  config.vm.network "forwarded_port", guest: 9090, host: 9090
  config.vm.network "forwarded_port", guest: 8500, host: 8500
end
