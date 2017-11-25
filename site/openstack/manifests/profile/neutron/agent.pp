class openstack::profile::neutron::agent {

  include ::openstack::profile::neutron::common
  include openstack::profile::common::interfaces

  $tnl_ip  = $openstack::profile::common::interfaces::tnl_ip
  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip
  $driver         = 'openvswitch'
  $metadata_protocol    = 'http'
}
