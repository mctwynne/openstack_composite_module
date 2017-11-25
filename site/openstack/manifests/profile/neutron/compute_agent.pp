class openstack::profile::neutron::compute_agent {

  include ::openstack::profile::neutron::common
  include openstack::profile::common::interfaces
  $tnl_ip  = $openstack::profile::common::interfaces::tnl_ip

  $driver         = 'openvswitch'
  $metadata_protocol    = 'http'
  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip

  class { '::ovn::controller':
    ovn_remote                => $controller_mgmt_ip,
    ovn_encap_ip              => $tnl_ip,
    ovn_bridge_mappings       => ['external:br-ex'],
    bridge_interface_mappings => ['br-ex:ens5'],
  }
}
