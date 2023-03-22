class profile::vault::server (
)
{
  include firewall
  
  class {'vault':
    bin_dir            => '/usr/bin',
    manage_storage_dir => true,
    enable_ui          => true,
    telemetry          => {
      prometheus_retention_time => "30s",
      disable_hostname          => true,
    },
    listener           => {
      'tcp' => {
        'address'     => '{{ GetInterfaceIP "eth1" }}:8200',
        'tls_disable' => 1,
      }
    }
  }

  firewall { '1001 allow vault access':
    dport  => [8200],
    proto  => 'tcp',
    action => 'accept',
  }
}
