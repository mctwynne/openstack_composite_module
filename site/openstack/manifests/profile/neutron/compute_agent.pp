class openstack::profile::neutron::compute_agent {

  include ::openstack::profile::neutron::common
  include openstack::profile::common::interfaces
  $tnl_ip  = $openstack::profile::common::interfaces::tnl_ip

  $driver         = 'linuxbridge'
  $metadata_protocol    = 'http'
  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip

  class { '::neutron::agents::ml2::linuxbridge':
    local_ip                    => $tnl_ip,
    tunnel_types                => ['vxlan'],
    l2_population               => true,
    physical_interface_mappings => ['external:ens5'],
  }
}
