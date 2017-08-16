class openstack::profile::mysql {
  include openstack::profile::common::interfaces
  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip

  $override_options = {
    'mysqld' => {
      'bind-address' => $mgmt_ip
    }
  }

  class { '::mysql::server':
    root_password => 'martin123martin',
    remove_default_accounts => true,
    override_options => $override_options,
  }

}
