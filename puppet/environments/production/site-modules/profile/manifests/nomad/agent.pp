class profile::nomad::agent (
  String $region,
  String $datacenter,
  Enum['WARN', 'INFO', 'DEBUG'] $log_level,
)
{
  include firewall
  include docker
  include java

  class { 'consul':
    manage_repo       => true,
    install_method    => 'package',
    bin_dir           => '/usr/bin',
    config_hash => {
      'data_dir'   => '/opt/consul',
      'client_addr'      => '0.0.0.0',
      'datacenter' => $datacenter,
      'log_level'  => $log_level,
      'node_name'  => $facts['fqdn'],
      'retry_join' => ['192.168.56.101'],
      'bind_addr'  => '{{ GetInterfaceIP "eth0" }}',
      'ui_config'        => {
        'enabled'            => true,
        'metrics_provider'   => 'prometheus',
        'metrics_proxy'      => {
          'base_url' => 'http://prometheus.service.tatooine.consul'
        }
      },
      'connect'          => {
        'enabled'        => true,
      },
      'ports'      => {
        "grpc"     => 8502,
      }
    },
  }

  class { 'cni::plugins':
    version  => '1.2.0',
    checksum => 'f3a841324845ca6bf0d4091b4fc7f97e18a623172158b72fc3fdcdb9d42d2d37',
    enable   => [
      'bridge',
    ]
  }

  -> class {'nomad':
    manage_repo       => true,
    install_method    => 'package',
    config_hash => {
      'region' => $region,
      'datacenter' => $datacenter,
      'log_level' => $log_level,
      'data_dir'   => '/opt/nomad',
      'client'     => {
        'enabled'          => true,
      },
      'plugin' => 
      [
        {
          'docker' => [
            {
              'config' => [  
                             {
                               'allow_privileged' => true,
                             }
                          ]
            }
          ]
        }
      ],
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
    dport  => [4646, 4647, 80, 443],
    proto  => 'tcp',
    action => 'accept',
  }
  
  firewall { '1002 allow consul access':
    dport  => [8300, 8301, 8302, 8303, 8500, 8502],
    proto  => 'tcp',
    action => 'accept',
  }

}
