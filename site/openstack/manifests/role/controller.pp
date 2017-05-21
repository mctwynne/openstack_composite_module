class openstack::role::controller inherits ::openstack::role {

  class {'openstack::profile::rabbitmq': }
  class {'::openstack::profile::mysql': }
  -> class {'::openstack::profile::keystone': }
  class {'::openstack::profile::glance': }
  -> class {'::openstack::profile::cinder': }
  -> class {'::openstack::profile::nova::api': }
  -> class {'::openstack::profile::neutron::api': }
  class {'::openstack::profile::horizon': }
}
