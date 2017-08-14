class openstack::profile::mysql {

  $override_options = {
    'mysqld' => {
      'bind-address' => '192.168.70.111'
    }
  }

  class { '::mysql::server':
    root_password => 'martin123martin',
    remove_default_accounts => true,
    override_options => $override_options,
  }

}
