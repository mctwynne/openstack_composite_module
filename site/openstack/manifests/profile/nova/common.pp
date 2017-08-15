class openstack::profile::nova::common {

  $base_url = 'http://192.168.70.111'

  $transport_url = os_transport_url({
    'transport' => 'rabbit',
    'host'      => '192.168.70.111',
    'username'  => 'nova',
    'password'  => 'an_even_bigger_secret',
  })

  class { '::nova':
    default_transport_url         => $transport_url,
    database_connection           => 'mysql+pymysql://nova:nova@192.168.70.111/nova?charset=utf8',
    api_database_connection       => 'mysql+pymysql://nova_api:nova@192.168.70.111/nova_api?charset=utf8',
    placement_database_connection => 'mysql+pymysql://nova_placement:nova@192.168.70.111/nova_placement?charset=utf8',
    rabbit_use_ssl                => false,
    glance_api_servers            => "${base_url}:9292",
    debug                         => true,
    notification_driver           => 'messagingv2',
    notify_on_state_change        => 'vm_and_task_state',
    #use_ssl                       => $::openstack_integration::config::ssl,
    #key_file                      => "/etc/nova/ssl/private/${::fqdn}.pem",
    #cert_file                     => $::openstack_integration::params::cert_path,
  }
  class { '::nova::network::neutron':
    neutron_auth_url => "${base_url}:35357/v3",
    neutron_url      => "${base_url}:9696",
    neutron_password => 'a_big_secret',
  }
}
