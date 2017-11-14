class openstack::profile::glance {

  include openstack::profile::common::interfaces
  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip
  $base_url = "http://${mgmt_ip}"
  $memcached_servers = $mgmt_ip

  rabbitmq_user { 'glance':
    admin    => true,
    password => 'super_secret',
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }

  rabbitmq_user_permissions { 'glance@/':
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
    require              => Class['::rabbitmq'],
  }

  class { '::glance::db::mysql':
    password => 'super_secret',
    allowed_hosts => '%',
  }

  include ::glance
  include ::glance::client

  class { '::glance::api::authtoken':
    password            => 'super_secret',
    user_domain_name    => 'Default',
    project_domain_name => 'Default',
    auth_url            => "${base_url}:35357/v3",
    auth_uri            => "${base_url}:5000/v3",
    memcached_servers   => $memcached_servers,
  }

  class { '::glance::api':
    debug               => true,
    database_connection => "mysql+pymysql://glance:super_secret@${mgmt_ip}/glance?charset=utf8",
    stores              => ['file'],
    default_store       => ['file'],
    bind_host           => $mgmt_ip,
    enable_v1_api       => false,
    enable_v2_api       => true,
  }

  class { '::glance::keystone::auth':
    public_url   => "${base_url}:9292",
    internal_url => "${base_url}:9292",
    admin_url    => "${base_url}:9292",
    password     => 'super_secret',
  }

  class { '::glance::notify::rabbitmq':
    default_transport_url => os_transport_url({
      'transport' => 'rabbit',
      'host'      => $mgmt_ip,
      'username'  => 'glance',
      'password'  => 'super_secret',
    }),
    notification_driver   => 'messagingv2',
  }
}
