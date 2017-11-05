class openstack::profile::mysql {
  include openstack::profile::common::interfaces
  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip

  $override_options = {
    'mysqld' => {
      'bind-address'    => $mgmt_ip,
      'max-connections' => 5000,
    }
  }

  class { '::mysql::server':
    root_password => 'super_secret',
    remove_default_accounts => true,
    override_options => $override_options,
  }

}
