class openstack::profile::nova::agent {

  include ::openstack::profile::nova::common
  include openstack::profile::common::interfaces
  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip

  $controller_mgmt_ip = hiera('controller_mgmt_ip')
  $base_url = "http://${controller_mgmt_ip}"

  class { '::nova::compute':
    vncproxy_host                 => $controller_mgmt_ip,
    vncserver_proxyclient_address => $mgmt_ip,
    vnc_enabled                   => true,
    instance_usage_audit          => true,
    instance_usage_audit_period   => 'hour',
  }
  class { '::nova::placement':
    auth_url => "${base_url}:35357/v3",
    password => 'a_big_secret',
  }
  class { '::nova::compute::libvirt':
    libvirt_virt_type     => 'kvm',
    libvirt_cpu_mode      => 'none',
    migration_support     => true,
    vncserver_listen      => '0.0.0.0',
    # virtlock and virtlog services resources are not idempotent
    # on Ubuntu, let's disable it for now.
    # https://tickets.puppetlabs.com/browse/PUP-6370
    virtlock_service_name => false,
    virtlog_service_name  => false,
  }
}
