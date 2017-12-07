class openstack::profile::neutron::common {
  $base_url = 'http://${ip_addr}'

  class { '::neutron':
    default_transport_url => os_transport_url({
      'transport' => 'rabbit',
      'host'      => $ip_addr,
      'username'  => 'neutron',
      'password'  => $openstack::config::password,
      }),
    allow_overlapping_ips => true,
    core_plugin           => $openstack::config::core_plugin,
    service_plugins       => $openstack::config::service_plugins,
    debug                 => $openstack::config::debug,
    bind_host             => $openstack::config::controller_mgmt_ip,
    global_physnet_mtu    => '1450',
  }

  class { '::neutron::plugins::ml2':
        type_drivers         => $openstack::config::type_drivers,
        tenant_network_types => $openstack::config::tenant_network_types,
        vni_ranges           => $openstack::config::vni_ranges,
        tunnel_id_ranges     => $openstack::config::tunnel_id_ranges,
        extension_drivers    => 'port_security',
        mechanism_drivers    => $openstack::config::mechanism_drivers,
        firewall_driver      => $openstack::config::firewall_driver,
  }
}
