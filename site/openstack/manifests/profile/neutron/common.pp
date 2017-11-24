class openstack::profile::neutron::common {

  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip
  $ip_addr = $controller_mgmt_ip
  $base_url = 'http://${ip_addr}'

  $driver = ['ovn']
  $firewall_driver  = 'iptables_hybrid'

  class { '::neutron':
    default_transport_url => os_transport_url({
      'transport' => 'rabbit',
      'host'      => $ip_addr,
      'username'  => 'neutron',
      'password'  => 'an_even_bigger_secret',
      }),
    allow_overlapping_ips => true,
    core_plugin           => 'neutron.plugins.ml2.plugin.Ml2Plugin',
    service_plugins       => ['networking_ovn.l3.l3_ovn.OVNL3RouterPlugin'],
    debug                 => true,
    bind_host             => $ip_addr,
    global_physnet_mtu    => '1450',
  }

  class { '::neutron::plugins::ml2':
    type_drivers         => ['geneve', 'vxlan', 'vlan', 'flat'],
    tenant_network_types => ['geneve', 'vxlan', 'vlan', 'flat'],
    vni_ranges           => ['1:5000'],
    extension_drivers    => 'port_security',
    mechanism_drivers    => $driver,
    firewall_driver      => $firewall_driver,
    overlay_ip_version   => 4,
  }
}
