class openstack::profile::memcached {
  include openstack::profile::common::interfaces
  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip

	class { 'memcached':
		listen_ip => $mgmt_ip
	}
}
