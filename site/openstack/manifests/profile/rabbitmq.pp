class openstack::profile::rabbitmq {

  include packagecloud
  include openstack::profile::common::interfaces
  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip

  packagecloud::repo { 'rabbitmq/rabbitmq-server':
    type => 'deb',
  }

  class { '::rabbitmq':
    service_manage    => false,
    node_ip_address   => $mgmt_ip,
    port              => '5672',
    delete_guest_user => true,
  }

}
