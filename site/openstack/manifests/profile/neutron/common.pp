class openstack::profile::neutron::common {

  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip
  $ip_addr = $controller_mgmt_ip
  $base_url = 'http://${ip_addr}'

  $driver = ['openvswitch', 'l2population']
  $firewall_driver  = 'iptables_hybrid'

  class { '::neutron':
    default_transport_url => os_transport_url({
      'transport' => 'rabbit',
      'host'      => $ip_addr,
      'username'  => 'neutron',
      'password'  => 'super_secret',
      }),
    allow_overlapping_ips => true,
    core_plugin           => 'ml2',
    service_plugins       => ['router', 'neutron_lbaas.services.loadbalancer.plugin.LoadBalancerPluginv2'],
    debug                 => true,
    bind_host             => $ip_addr,
    global_physnet_mtu    => '1450',
  }

  class { '::neutron::plugins::ml2':
        type_drivers         => ['vxlan', 'gre', 'geneve', 'vlan', 'flat'],
        tenant_network_types => ['vxlan', 'gre', 'geneve', 'vlan'],
        vni_ranges           => ['100:2000'],
        tunnel_id_ranges     => ['100:2000'],
        extension_drivers    => 'port_security',
        mechanism_drivers    => $driver,
        firewall_driver      => $firewall_driver,
  }
}
