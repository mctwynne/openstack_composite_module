class openstack::profile::nova::common {

  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip
  $base_url = "http://${controller_mgmt_ip}"

  $transport_url = os_transport_url({
    'transport' => 'rabbit',
    'host'      => $controller_mgmt_ip,
    'username'  => 'nova',
    'password'  => 'an_even_bigger_secret',
  })

  class { '::nova':
    default_transport_url         => $transport_url,
    database_connection           => "mysql+pymysql://nova:nova@${controller_mgmt_ip}/nova?charset=utf8",
    api_database_connection       => "mysql+pymysql://nova_api:nova@${controller_mgmt_ip}/nova_api?charset=utf8",
    placement_database_connection => "mysql+pymysql://nova_placement:nova@${controller_mgmt_ip}/nova_placement?charset=utf8",
    rabbit_use_ssl                => false,
    glance_api_servers            => "${base_url}:9292",
    debug                         => true,
    notification_driver           => 'messagingv2',
    notify_on_state_change        => 'vm_and_task_state',
  }
  class { '::nova::network::neutron':
    neutron_auth_url => "${base_url}:35357/v3",
    neutron_url      => "${base_url}:9696",
    neutron_password => 'a_big_secret',
  }
}
