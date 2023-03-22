# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
# Update repos
wget https://apt.puppet.com/puppet7-release-bullseye.deb
dpkg -i puppet7-release-bullseye.deb

# Update packages
apt update -y

# Install Ruby 2.7
apt install -y ruby rubygems

# Install r10k for Puppet
gem install r10k

# Install Puppet
apt install -y puppet-agent

# Install modules for Puppet
cd /tmp/vagrant-puppet/environments/production/
r10k puppetfile install

SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "debian/bullseye64"

  config.vm.provision "shell",
                      inline: $script

  config.vm.synced_folder ".", "/vagrant", type: "rsync",
                          rsync__exclude: ".git/"
  
  config.vm.provision "puppet" do |puppet|
    puppet.options = "--verbose"
    puppet.environment_path = "puppet/environments"
    puppet.environment = "production"
  end

  # configure RAM and CPUs
  config.vm.provider "libvirt" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  # Server (nomad / consul)
  config.vm.define "server-dc1-1" do |n|
    n.vm.hostname = "server-dc1-1"
    n.vm.network "private_network", ip: "192.168.56.101"
  end

  # 2-node configuration
  (2..3).each do |i|
    config.vm.define "client-dc1-#{i}" do |n|
      n.vm.hostname = "client-dc1-#{i}"
      n.vm.network "private_network", ip: "192.168.56.#{i+100}"
    end
  end

end
