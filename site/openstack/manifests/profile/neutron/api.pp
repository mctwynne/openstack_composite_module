class openstack::profile::neutron::api {

  include ::openstack::profile::neutron::common
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
    password => $openstack::config::password,
    allowed_hosts => '%',
  }
  class { '::neutron::keystone::auth':
    public_url   => "${base_url}:9696",
    internal_url => "${base_url}:9696",
    admin_url    => "${base_url}:9696",
    password     => $openstack::config::password,
  }
  class { '::neutron::client': }
  class { '::neutron::keystone::authtoken':
    password            => $openstack::config::password,
    user_domain_name    => 'Default',
    project_domain_name => 'Default',
    auth_url            => "${base_url}:35357/v3",
    auth_uri            => "${base_url}:5000/v3",
    memcached_servers   => $memcached_servers,
  }
  class { '::neutron::server':
    database_connection => "mysql+pymysql://neutron:super_secret@${mgmt_ip}/neutron?charset=utf8",
    service_providers   => $openstack::config::service_providers,
    sync_db             => true,
    router_distributed  => $openstack::config::router_distributed,
  }
  class { '::neutron::server::notifications':
    auth_url => "http://${mgmt_ip}:35357/v3",
    password => $openstack::config::password,
  }
}
