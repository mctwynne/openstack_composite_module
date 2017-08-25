class openstack::profile::heat {
  include openstack::profile::common::interfaces
  $mgmt_ip = openstack::profile::common::interfaces::mgmt_ip


  rabbitmq_user { 'heat':
    admin    => true,
    password => 'super_secret',
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }

  rabbitmq_user_permissions { 'heat@/':
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
    require              => Class['::rabbitmq'],
  }

  class { '::heat::db::mysql':
    password      => 'super_secret',
    host          => $mgmt_ip,
    allowed_hosts => '%',
  }

  class { '::heat::keystone::authtoken':
    password          => 'super_secret',
    auth_url          => "http://${mgmt_ip}:35357/",
    auth_uri          => "http://${mgmt_ip}:5000/",
    memcached_servers => $mgmt_ip,
  }

  class { '::heat::keystone::auth':
    password         => 'super_secret',
    public_url   => "http://${mgmt_ip}:8004/v1/%(tenant_id)s",
    admin_url   => "http://${mgmt_ip}:8004/v1/%(tenant_id)s",
    internal_url   => "http://${mgmt_ip}:8004/v1/%(tenant_id)s",
  }

  class { '::heat::keystone::auth_cfn':
    password         => 'super_secret',
    public_url   => "http://${mgmt_ip}:8000/v1",
    admin_url   => "http://${mgmt_ip}:8000/v1",
    internal_url   => "http://${mgmt_ip}:8000/v1",
  }

  class { '::heat':
    database_connection => "mysql+pymysql://heat:super_secret@${mgmt_ip}/heat",
    rabbit_host         => $mgmt_ip,
    rabbit_userid       => 'heat',
    rabbit_password     => 'super_secret',
    debug               => true,
  }

  class { '::heat::api': }
  class { '::heat::api_cfn': }

  class { '::heat::engine':
    auth_encryption_key => '1234567890AZERTYUIOPMLKJHGFDSQ12',
  }
}
