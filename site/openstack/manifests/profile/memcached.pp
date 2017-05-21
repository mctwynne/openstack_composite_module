class openstack::profile::memcached {

  class { 'memcached':
    max_memory => '10%'
  }

}
