class openstack::role::controller inherits ::openstack::role {

  class {'openstack::profile::rabbitmq': }
  class {'::openstack::profile::mysql': }
  -> class {'::openstack::profile::keystone': }
  class {'::openstack::profile::glance': }
  -> class {'::openstack::profile::nova::api': }
  -> class {'::openstack::profile::neutron::api': }
  -> class {'::openstack::profile::neutron::control_agent': }
  class {'::openstack::profile::horizon': }
  class {'::openstack::profile::heat': }
}
