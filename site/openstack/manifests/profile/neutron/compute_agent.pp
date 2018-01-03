class openstack::profile::neutron::compute_agent {

  include ::openstack::profile::neutron::common

  $metadata_protocol    = 'http'
  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => true,
    enabled          => true,
    manage_vswitch   => true,
    l2_population    => true,
    local_ip         => $openstack::config::tnl_ip,
    tunnel_types     => $openstack::config::ovs_tunnel_types,
    bridge_uplinks   => $openstack::config::bridge_uplinks,
    bridge_mappings  => $openstack::config::bridge_mappings,
    firewall_driver  => $openstack::config::firewall_driver,
  }

  if $openstack::config::router_distributed {
    class { '::neutron::agents::metadata':
      debug                 => $openstack::config::debug,
      metadata_insecure     => false,
      shared_secret         => 'a_big_secret',
      metadata_protocol     => $metadata_protocol,
      metadata_ip           => $openstack::config::controller_mgmt_ip,
    }

    class { '::neutron::agents::l3':
      interface_driver => $openstack::config::l3_interface_driver,
      debug            => $openstack::config::debug,
      agent_mode       => $openstack::config::l3_compute_agent_mode,
    }
  }
}
