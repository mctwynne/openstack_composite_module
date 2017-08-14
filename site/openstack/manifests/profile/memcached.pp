class openstack::profile::memcached {
	class { 'memcached':
		listen_ip => '192.168.70.111'
	}
}
