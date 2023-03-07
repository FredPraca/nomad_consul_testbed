class profile::base {

  #the base profile should include component modules that will be on all nodes
  # include ntp
  class { 'motd':
     content => "Machine gérée via Puppet\nMerci de vérifier que votre manipulation ne peut être faite effectuée via Puppet\n",
  }

  yumrepo {'hashicorp':
    ensure => 'present',
    name => 'Hashicorp-stable',
    descr => 'Hashicorp Products repo',
    baseurl => 'https://rpm.releases.hashicorp.com/RHEL/$releasever/$basearch/stable',
    enabled => '1',
    gpgcheck => '0',
    target => '/etc/yum.repo.d/hashicorp.repo'
  }

}
