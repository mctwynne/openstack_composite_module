class openstack::profile::neutron::api {

  require ::openstack::profile::neutron::common
  include openstack::profile::common::interfaces

  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip
  $base_url = "http://${mgmt_ip}"
  $memcached_servers = $mgmt_ip

  rabbitmq_user { 'neutron':
    admin    => true,
    password => 'super_secret',
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }
  rabbitmq_user_permissions { 'neutron@/':
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
    require              => Class['::rabbitmq'],
  }
  Rabbitmq_user_permissions['neutron@/'] -> Service<| tag == 'neutron-service' |>

  class { '::neutron::db::mysql':
    password      => 'super_secret',
    allowed_hosts => '%',
    require       => Class['::mysql::server'],
  }

  class { '::neutron::keystone::auth':
    public_url   => "${base_url}:9696",
    internal_url => "${base_url}:9696",
    admin_url    => "${base_url}:9696",
    password     => 'super_secret',
  }
  class { '::neutron::client': }
  class { '::neutron::keystone::authtoken':
    password            => 'super_secret',
    user_domain_name    => 'Default',
    project_domain_name => 'Default',
    auth_url            => "${base_url}:35357/v3",
    auth_uri            => "${base_url}:5000/v3",
    memcached_servers   => $memcached_servers,
  }
  class { '::neutron::server':
    database_connection => "mysql+pymysql://neutron:super_secret@${mgmt_ip}/neutron?charset=utf8",
    sync_db             => true,
    router_distributed  => true,
  }
  class { '::neutron::server::notifications':
    auth_url => "http://${mgmt_ip}:35357/v3",
    password => 'super_secret',
  }

  #Class['::neutron::db::mysql'] -> Class['::openstack::profile::neutron::common']
  Class['::neutron::db::mysql'] -> Class['::neutron::server']
  Class['::neutron::db::mysql'] -> Exec['neutron-db-sync']
}
