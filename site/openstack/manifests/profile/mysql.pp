class openstack::profile::mysql {

  class { '::mysql::server':
    root_password => 'martin123martin',
    remove_default_accounts => true,
  }

}
