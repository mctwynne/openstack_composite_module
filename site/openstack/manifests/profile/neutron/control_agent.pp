class openstack::profile::neutron::control_agent {
  include ::openstack::profile::neutron::common

  $metadata_protocol    = 'http'

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => true,
    manage_vswitch   => true,
    l2_population    => true,
    enabled          => true,
    local_ip         => $openstack::config::tnl_ip,
    tunnel_types     => $openstack::config::ovs_tunnel_types,
    bridge_uplinks   => $openstack::config::bridge_uplinks,
    bridge_mappings  => $openstack::config::bridge_mappings,
    firewall_driver  => $openstack::config::firewall_driver,
  }

  class { '::neutron::agents::metadata':
    debug                 => true,
    shared_secret         => 'a_big_secret',
    metadata_protocol     => $metadata_protocol,
    metadata_insecure     => false,
    metadata_ip           => $openstack::config::controller_mgmt_ip,
  }

  class { '::neutron::agents::l3':
    interface_driver => $openstack::config::l3_interface_driver,
    debug            => true,
    if $openstack::config::enable_dvr {
      agent_mode       => 'dvr_snat',
    }
  }

  class { '::neutron::agents::dhcp':
    interface_driver => $openstack::config::l3_interface_driver,
    debug            => true,
  }

  if $openstack::config::enable_lbaas {
    include openstack::profile::neutron::lbaas
  }
}
