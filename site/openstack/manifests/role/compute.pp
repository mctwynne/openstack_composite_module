class openstack::role::compute inherits ::openstack::role {

  class {'openstack::profile::nova::agent': }
  class {'openstack::profile::neutron::agent': }

}
