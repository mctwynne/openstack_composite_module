class openstack::profile::keystone {

  include openstack::profile::common::interfaces
  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip
  $base_url = "http://${mgmt_ip}"

  include ::apache

  class { 'keystone':
  admin_token         => 'random_uuid',
  database_connection => "mysql+pymysql://keystone:keystone@${mgmt_ip}/keystone",
  service_name        => 'httpd',
  }

  class { 'keystone::db::mysql':
    password      => 'keystone',
    allowed_hosts => '%',
  }

  class { '::keystone::wsgi::apache':
    workers    => 2,
    servername => 'controller',
    ssl        => false,
  }

  # Workaround to purge Keystone vhost that is provided & activated by default with running
  # Canonical packaging (called 'keystone').
  if ($::operatingsystem == 'Ubuntu') and (versioncmp($::operatingsystemmajrelease, '16') >= 0) {
    ensure_resource('file', '/etc/apache2/sites-available/keystone.conf', {
      'ensure'  => 'absent',
    })
    ensure_resource('file', '/etc/apache2/sites-enabled/keystone.conf', {
      'ensure'  => 'absent',
    })

    Package['keystone'] -> File['/etc/apache2/sites-available/keystone.conf']
    -> File['/etc/apache2/sites-enabled/keystone.conf'] ~> Anchor['keystone::install::end']
  }

  class { 'keystone::roles::admin':
    email    => 'admin@example.com',
    password => 'super_secret',
  }

  # Installs the service user endpoint.
  class { 'keystone::endpoint':
    default_domain => 'default',
    public_url     => "${base_url}:5000/v3",
    admin_url      => "${base_url}:35357/v3",
    internal_url   => "${base_url}:5000/v3",
    version        => '',
  }

  # Remove the admin_token_auth paste pipeline.
  # After the first puppet run this requires setting keystone v3
  # admin credentials via /root/openrc or as environment variables.
  include keystone::disable_admin_token_auth
  ### End keystone

  class { '::openstack_extras::auth_file':
    password       => 'super_secret',
    project_domain => 'default',
    user_domain    => 'default',
    auth_url       => "${base_url}:5000/v3",
  }

  keystone_domain { 'demodomain':
    ensure =>  present,
  }
  keystone_tenant { 'demo::demodomain':
    ensure => present,
    domain => 'demodomain',
  }
  keystone_user { 'demo::demodomain':
    ensure   => present,
    password => 'abc123',
    domain   => 'demodomain',
  }
  keystone_user_role { 'demo::demodomain@demo::demodomain':
    ensure => present,
    roles  => ['admin']
  }
}
