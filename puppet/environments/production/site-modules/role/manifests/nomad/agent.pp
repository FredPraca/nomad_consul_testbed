class role::nomad::agent {
  include profile::base
  include profile::nomad::agent
  #  include profile::docker::host
}
