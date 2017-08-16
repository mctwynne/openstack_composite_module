class openstack::profile::horizon {

  include openstack::profile::common::interfaces
  $mgmt_ip = $openstack::profile::common::interfaces::mgmt_ip

  class { '::horizon':
    servername                   =>  'controller.tuxadero.com',
    secret_key                   => 'big_secret',
    allowed_hosts                => '*',
    keystone_url                 => "http://${mgmt_ip}:5000/v3",
    # need to disable offline compression due to
    # https://bugs.launchpad.net/ubuntu/+source/horizon/+bug/1424042
    compress_offline             => false,
    keystone_multidomain_support => true,
  }
}
