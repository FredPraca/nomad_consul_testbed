class profile::base {

  #the base profile should include component modules that will be on all nodes
  # include ntp
  class { 'motd':
     content => "Machine gérée via Puppet\nMerci de vérifier que votre manipulation ne peut être faite effectuée via Puppet\n",
  }
}
