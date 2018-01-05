class openstack::profile::neutron::lbaas {
  class { '::neutron::services::lbaas::octavia':
    allocates_vip  => true,
    admin_user     => 'octavia',
    admin_password => 'super_secret',
  }
}
