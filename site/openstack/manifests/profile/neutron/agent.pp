class openstack::profile::neutron::agent {

  include ::openstack::profile::neutron::common
  include openstack::profile::common::interfaces

  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip
  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip
  $driver         = 'openvswitch'
  $metadata_protocol    = 'http'

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => true,
    local_ip         => $mgmt_ip,
    enabled          => true,
    tunnel_types     => ['vxlan'],
    bridge_mappings  => ['external:br-ex'],
    manage_vswitch   => true,
    firewall_driver  => 'iptables_hybrid',
    l2_population    => true,
  }

  class { '::neutron::agents::metadata':
    debug                 => true,
    shared_secret         => 'a_big_secret',
    metadata_workers      => 2,
    metadata_protocol     => $metadata_protocol,
    metadata_insecure     => false,
    metadata_ip           => $controller_mgmt_ip,
  }

  class { '::neutron::agents::l3':
    interface_driver => $driver,
    debug            => true,
    agent_mode       => 'dvr_snat',
  }

  class { '::neutron::agents::dhcp':
    interface_driver => $driver,
    debug            => true,
  }
}
