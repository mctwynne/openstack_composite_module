class openstack::profile::cinder {

  $memcached_servers = '127.0.0.1'
  $base_url = 'http://192.168.0.10'

  rabbitmq_user { 'cinder':
    admin    => true,
    password => 'an_even_bigger_secret',
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }

  rabbitmq_user_permissions { 'cinder@/':
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
    require              => Class['::rabbitmq'],
  }

  class { '::cinder::db::mysql':
    password => 'cinder',
  }

  class { '::cinder::keystone::authtoken':
    password            => 'a_big_secret',
    user_domain_name    => 'Default',
    project_domain_name => 'Default',
    auth_url            => "${base_url}:35357/v3",
    auth_uri            => "${base_url}:5000/v3",
    memcached_servers   => $memcached_servers,
  }

  class { '::cinder':
    default_transport_url => os_transport_url({
      'transport' => 'rabbit',
      'host'      => '127.0.0.1',
      'username'  => 'cinder',
      'password'  => 'an_even_bigger_secret',
    }),
    database_connection   => 'mysql+pymysql://cinder:cinder@127.0.0.1/cinder?charset=utf8',
    debug                 => true,
  }

  class { '::cinder::keystone::auth':
    public_url      => "${base_url}:8776/v1/%(tenant_id)s",
    internal_url    => "${base_url}:8776/v1/%(tenant_id)s",
    admin_url       => "${base_url}:8776/v1/%(tenant_id)s",
    public_url_v2   => "${base_url}:8776/v2/%(tenant_id)s",
    internal_url_v2 => "${base_url}:8776/v2/%(tenant_id)s",
    admin_url_v2    => "${base_url}:8776/v2/%(tenant_id)s",
    public_url_v3   => "${base_url}:8776/v3/%(tenant_id)s",
    internal_url_v3 => "${base_url}:8776/v3/%(tenant_id)s",
    admin_url_v3    => "${base_url}:8776/v3/%(tenant_id)s",
    password        => 'a_big_secret',
  }

  include ::apache
  class { '::cinder::wsgi::apache':
    #bind_host => $::openstack_integration::config::ip_for_url,
    #ssl       => $::openstack_integration::config::ssl,
    #ssl_key   => "/etc/cinder/ssl/private/${::fqdn}.pem",
    #ssl_cert  => $::openstack_integration::params::cert_path,
    workers => 2,
    ssl     => false,
  }

  class { '::cinder::api':
    default_volume_type => 'BACKEND_1',
    public_endpoint     => "${base_url}:8776",
    service_name        => 'httpd',
    #keymgr_api_class           => $keymgr_api_class,
    #keymgr_encryption_api_url  => $keymgr_encryption_api_url,
    #keymgr_encryption_auth_url => $keymgr_encryption_auth_url,
  }

  cinder::backend::rbd { 'BACKEND_1':
    rbd_user           => 'openstack',
    rbd_pool           => 'cinder',
    rbd_secret_uuid    => '7200aea0-2ddd-4a32-aa2a-d49f66ab554c',
    manage_volume_type => true,
  }

  class { '::cinder::backends':
    enabled_backends => ['BACKEND_1'],
  }
}

