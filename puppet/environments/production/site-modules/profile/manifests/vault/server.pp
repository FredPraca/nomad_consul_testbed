class profile::vault::server (
)
{
  include firewall

  file {'/opt/vault':
    ensure => directory,
    recurse => true,
  }
  
  -> class {'vault':
    bin_dir            => '/usr/bin',
    manage_storage_dir => true,
    enable_ui          => true,
    
    telemetry          => {
      prometheus_retention_time => "30s",
      disable_hostname          => true,
    },
    listener           => [
      {
        'tcp' => {
          'address'     => '{{ GetInterfaceIP "eth1" }}:8200',
          'tls_disable' => 1,
        }
      },
      {
        'tcp' => {
          'address'     => '127.0.0.1:8200',
          'tls_disable' => 1,
        }
      },
    ],
    storage  => {
      raft => {
        path => '/opt/vault/data'
      }
    },
    api_addr => 'http://{{ GetInterfaceIP "eth1" }}:8200',
    extra_config => {
      'service_registration' => {
        'consul' => {
          'address'  => '127.0.0.1:8500'
        }
      },
      'cluster_addr' => 'http://127.0.0.1:8201',
    }
  }

  firewall { '1001 allow vault access':
    dport  => [8200, 8201],
    proto  => 'tcp',
    action => 'accept',
  }
}
