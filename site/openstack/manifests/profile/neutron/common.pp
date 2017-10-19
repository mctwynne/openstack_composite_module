class openstack::profile::neutron::common {

  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip
  $ip_addr = $controller_mgmt_ip
  $base_url = 'http://${ip_addr}'

  $driver = ['openvswitch', 'l2population']
  $firewall_driver  = 'openvswitch'

  class { '::neutron':
    default_transport_url => os_transport_url({
      'transport' => 'rabbit',
      'host'      => $ip_addr,
      'username'  => 'neutron',
      'password'  => 'an_even_bigger_secret',
      }),
    allow_overlapping_ips => true,
    core_plugin           => 'ml2',
    service_plugins       => ['router'],
    debug                 => true,
    bind_host             => $ip_addr,
    global_physnet_mtu    => '1450',
  }

  class { '::neutron::plugins::ml2':
        type_drivers         => ['vxlan', 'vlan', 'flat'],
        tenant_network_types => ['vxlan', 'vlan', 'flat'],
        extension_drivers    => 'port_security',
        mechanism_drivers    => $driver,
        firewall_driver      => $firewall_driver,
  }
}
