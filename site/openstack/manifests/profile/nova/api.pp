class openstack::profile::nova::api {

  include ::openstack::profile::nova::common
  include openstack::profile::common::interfaces
  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip
  $base_url = "http://${mgmt_ip}"
  $memcached_servers = $mgmt_ip

  rabbitmq_user { 'nova':
    admin    => true,
    password => 'super_secret',
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }
  rabbitmq_user_permissions { 'nova@/':
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
    require              => Class['::rabbitmq'],
  }
  Rabbitmq_user_permissions['nova@/'] -> Service<| tag == 'nova-service' |>

  class { '::nova::db::mysql':
    password => 'super_secret',
    allowed_hosts => '%',
  }
  class { '::nova::db::mysql_api':
    password    => 'super_secret',
    allowed_hosts => '%',
  }
  class { '::nova::keystone::auth':
    public_url   => "${base_url}:8774/v2.1",
    internal_url => "${base_url}:8774/v2.1",
    admin_url    => "${base_url}:8774/v2.1",
    password     => 'super_secret',
  }
  class { '::nova::keystone::authtoken':
    password            => 'super_secret',
    user_domain_name    => 'Default',
    project_domain_name => 'Default',
    auth_url            => "${base_url}:35357/v3",
    auth_uri            => "${base_url}:5000/v3",
    memcached_servers   => $memcached_servers,
  }
  class { '::nova::keystone::auth_placement':
    public_url   => "${base_url}:8778/placement",
    internal_url => "${base_url}:8778/placement",
    admin_url    => "${base_url}:8778/placement",
    password     => 'super_secret',
  }
  class { '::nova::api':
    api_bind_address                     => $mgmt_ip,
    neutron_metadata_proxy_shared_secret => 'a_big_secret',
    metadata_workers                     => 2,
    osapi_compute_workers                => 2,
    default_floating_pool                => 'public',
    sync_db_api                          => true,
    install_cinder_client                => false,
  }
  class { '::nova::wsgi::apache_placement':
    bind_host => $mgmt_ip,
    api_port  => '8778',
    ssl       => false,
    workers   => '2',
  }
  class { '::nova::placement':
    auth_url => "${base_url}:35357/v3",
    password => 'super_secret',
  }
  class { '::nova::conductor': }
  class { '::nova::consoleauth': }
  class { '::nova::cron::archive_deleted_rows': }
  class { '::nova::scheduler': }
  class { '::nova::scheduler::filter': }
  class { '::nova::vncproxy': }
}
