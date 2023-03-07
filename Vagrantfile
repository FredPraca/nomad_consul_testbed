# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
# Update repos
rpm -Uvh https://yum.puppet.com/puppet7-release-el-7.noarch.rpm

# Update packages
yum update -y

# Install Ruby 2.7
yum install -y centos-release-scl-rh centos-release-scl rubygems
yum --enablerepo=centos-sclo-rh install -y rh-ruby27 
scl enable rh-ruby27 bash
source scl_source enable rh-ruby27
# Install r10k for Puppet
gem install r10k

# Install Puppet
yum install -y puppet-agent

# Install modules for Puppet
cd /tmp/vagrant-puppet/environments/production/
r10k puppetfile install

# Install CNI
curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v1.0.0.tgz
mkdir -p /opt/cni/bin
tar -C /opt/cni/bin -xzf cni-plugins.tgz
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "generic/centos7"

  config.vm.provision "shell",
                      inline: $script

  config.vm.provision "puppet" do |puppet|
    puppet.options = "--verbose --debug"
    puppet.environment_path = "puppet/environments"
    puppet.environment = "production"
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
