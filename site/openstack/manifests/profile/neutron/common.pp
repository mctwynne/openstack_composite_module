class openstack::profile::neutron::common {

  $base_url = 'http://192.168.0.10'

  $firewall_driver  = 'openvswitch'
  $mechanism_drivers = 'openvswitch'

  class { '::neutron':
    default_transport_url => os_transport_url({
      'transport' => 'rabbit',
      'host'      => '192.168.0.10',
      'username'  => 'neutron',
      'password'  => 'an_even_bigger_secret',
      }),
    allow_overlapping_ips => true,
    core_plugin           => 'ml2',
    service_plugins       => ['router', 'neutron_lbaas.services.loadbalancer.plugin.LoadBalancerPluginv2'],
    debug                 => true,
    bind_host             => '192.168.0.10',
    #use_ssl              => $::openstack_integration::config::ssl,
    #cert_file            => $::openstack_integration::params::cert_path,
    #key_file             => "/etc/neutron/ssl/private/${::fqdn}.pem",
  }
  class { '::neutron::plugins::ml2':
        type_drivers         => ['vxlan', 'vlan', 'flat'],
        tenant_network_types => ['vxlan', 'vlan', 'flat'],
        extension_drivers    => 'port_security',
        mechanism_drivers    => $driver,
        firewall_driver      => $firewall_driver,
  }
}
