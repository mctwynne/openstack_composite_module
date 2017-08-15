class openstack::profile::nova::agent {

  include ::openstack::profile::nova::common

  $base_url = 'http://192.168.70.111'

  class { '::nova::compute':
    vncproxy_host                 => '192.168.70.111',
    vncserver_proxyclient_address => '192.168.70.112',
    vnc_enabled                   => true,
    instance_usage_audit          => true,
    instance_usage_audit_period   => 'hour',
    #keymgr_api_class             => $keymgr_api_class,
    #barbican_auth_endpoint       => $keymgr_auth_endpoint,
    #barbican_endpoint            => $barbican_endpoint,
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
