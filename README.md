Puppet/Nomad-Consul Testbench
====

This repository aims at providing a Vagrant environment for testing Nomad thanks to Puppet.

Puppet
--

The Puppet environment is designed as role/profile ([see Puppet documentation](https://www.puppet.com/docs/puppet/7/the_roles_and_profiles_method.html)).
You can also use this to test Puppet stuff.

Nomad
--

There are three virtual machines:

- A Nomad/Consul server
- Two Nomad agents

UI are available respectively at:

- [Consul](http://192.168.56.101:8500/)
- [Nomad](http://192.168.56.101:4646/)


Building
---

This is easy, just type `vagrant up`.

Everything is already packaged but this takes time to build at the first time, be patient!


Have fun!
