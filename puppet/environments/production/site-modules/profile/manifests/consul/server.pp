class profile::consul::server (
  String $servername,
  String $datacenter,
  Enum['WARN', 'INFO', 'DEBUG'] $log_level,
)
{
  
  class {'consul':
    manage_repo       => true,
    install_method    => 'package',
    bin_dir           => '/usr/bin',
    config_hash => {
      'bootstrap_expect' => 1,
      'client_addr'      => '0.0.0.0',
      'bind_addr'        => '{{ GetInterfaceIP "eth1" }}',
      'data_dir'         => '/opt/consul',
      'datacenter'       => $datacenter,
      'log_level'        => $log_level,
      'node_name'        => $servername,
      'server'           => true,
      'ui_config'        => {
        'enabled'            => true,
        'metrics_provider'   => 'prometheus',
        'metrics_proxy'      => {
          'base_url' => 'http://prometheus.service.tatooine.consul'
        }
      },
      'connect'          => {
        'enabled'        => true,
      }
    },
  }

  firewall { '1001 allow consul access':
    dport  => [8300, 8301, 8302, 8500, 8502, 8600, 80, 443],
    proto  => 'tcp',
    action => 'accept',
  }
}
