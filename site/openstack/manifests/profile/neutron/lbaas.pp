class openstack::profile::neutron::lbaas {
  class { '::neutron::agents::lbaas':
  }
}
