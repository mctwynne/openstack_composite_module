class openstack::profile::neutron::compute_agent {

  include ::openstack::profile::neutron::common
  include openstack::profile::common::interfaces
  $tnl_ip  = $openstack::profile::common::interfaces::tnl_ip

  $driver         = 'openvswitch'
  $metadata_protocol    = 'http'
  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => true,
    local_ip         => $tnl_ip,
    enabled          => true,
    tunnel_types     => ['vxlan', 'gre', 'geneve'],
    bridge_uplinks   => ['br-ex:ens5'],
    bridge_mappings  => ['external:br-ex'],
    manage_vswitch   => true,
    firewall_driver  => 'iptables_hybrid',
    l2_population    => true,
  }

  class { '::neutron::agents::metadata':
    debug                 => true,
    shared_secret         => 'a_big_secret',
    metadata_protocol     => $metadata_protocol,
    metadata_insecure     => false,
    metadata_ip           => $controller_mgmt_ip,
  }

  class { '::neutron::agents::l3':
    interface_driver => $driver,
    debug            => true,
    agent_mode       => 'dvr',
  }
}
