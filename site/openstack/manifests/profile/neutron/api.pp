class openstack::profile::neutron::api {

  include ::openstack::profile::neutron::common
  include openstack::profile::common::interfaces

  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip
  $base_url = "http://${mgmt_ip}"
  $memcached_servers = $mgmt_ip

  rabbitmq_user { 'neutron':
    admin    => true,
    password => 'an_even_bigger_secret',
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
    password => 'neutron',
    allowed_hosts => '%',
  }
  class { '::neutron::keystone::auth':
    public_url   => "${base_url}:9696",
    internal_url => "${base_url}:9696",
    admin_url    => "${base_url}:9696",
    password     => 'a_big_secret',
  }
  class { '::neutron::client': }
  class { '::neutron::keystone::authtoken':
    password            => 'a_big_secret',
    user_domain_name    => 'Default',
    project_domain_name => 'Default',
    auth_url            => "${base_url}:35357/v3",
    auth_uri            => "${base_url}:5000/v3",
    memcached_servers   => $memcached_servers,
  }
  class { '::neutron::server':
    database_connection => "mysql+pymysql://neutron:neutron@${mgmt_ip}/neutron?charset=utf8",
    service_providers   => ['FIREWALL:Iptables:neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver:default'],
    sync_db             => true,
    api_workers         => 2,
    rpc_workers         => 2,
    router_distributed  => true,
  }
  class { '::neutron::server::notifications':
    auth_url => "http://${mgmt_ip}:35357/v3",
    password => 'a_big_secret',
  }
}
