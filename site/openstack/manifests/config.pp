class openstack::config {
  # Network
  $mgmt_interface = 'ens3'
  $tnl_interface = 'ens4'
  # We use sed in cloud-init to modify this IP
  $controller_mgmt_ip = '192.168.80.111'
  $mgmt_ip = $facts['networking']['interfaces'][$mgmt_interface]['ip']
  $tnl_ip = $facts['networking']['interfaces'][$tnl_interface]['ip']

  # LBaaS
  $enable_lbaas = true

  # Neutron
  $router_distributed = false
  $core_plugin = 'ml2'
  $mechanism_drivers = ['openvswitch', 'l2population']
  $firewall_driver = 'iptables_hybrid'
  $ovs_tun_types = ['vxlan', 'gre', 'geneve']
  $global_physnet_mtu = '1450'
  $type_drivers         = ['vxlan', 'gre', 'geneve', 'vlan', 'flat']
  $tenant_network_types = ['vxlan', 'gre', 'geneve', 'vlan']
  $vni_ranges           = ['100:2000']
  $tunnel_id_ranges     = ['100:2000']
  $bridge_uplinks   => ['br-ex:ens5']
  $bridge_mappings  => ['external:br-ex']
  $l3_interface_driver = 'openvswitch'

  if $router_distributed {
    $l3_network_agent_mode = 'dvr_snat'
    $l3_compute_agent_mode = 'snat'
    $enable_distributed_routing = true
  }
  else {
    $l3_network_agent_mode = $::os_service_default
    $l3_compute_agent_mode = $::os_service_default
    $enable_distributed_routing = false
  }

  if $enable_lbaas {
    $service_plugins = ['router', 'neutron_lbaas.services.loadbalancer.plugin.LoadBalancerPluginv2']
    $service_providers = ['LOADBALANCERV2:Haproxy:neutron_lbaas.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default']
  }
  else {
    $service_plugins = ['router']
    $service_providers = $::os_service_default
  }

  # General
  $password = 'super_secret'
  $debug = true
}
