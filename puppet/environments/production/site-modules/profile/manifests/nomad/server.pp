class profile::nomad::server (
  String $region,
  String $datacenter,
  String $node_name,
  Enum['WARN', 'INFO', 'DEBUG'] $log_level,
)
{
  include firewall
  
  class {'nomad':
    manage_repo       => true,
    install_method    => 'package',
    config_hash => {
      'region' => $region,
      'datacenter' => $datacenter,
      'log_level' => $log_level,
      'data_dir'   => '/opt/nomad',
      'server'     => {
        'enabled'          => true,
        'bootstrap_expect' => 1,
      },
      'telemetry' => [
        {
          'collection_interval' => '1s',
          'disable_hostname' => true,
          'prometheus_metrics' => true,
          'publish_allocation_metrics' => true,
          'publish_node_metrics' => true
        }
      ],
    }
  }

  firewall { '1001 allow nomad access':
    dport  => [4646, 4647, 4648, 80, 443],
    proto  => 'tcp',
    action => 'accept',
  }
  
  firewall { '1002 allow consul access':
    dport  => [8300, 8301, 8302, 8500, 8502],
    proto  => 'tcp',
    action => 'accept',
  }

}
