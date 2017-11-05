class openstack::profile::common::interfaces {
  $mgmt_interface = 'ens3'
  $tnl_interface = 'ens4'
  $controller_mgmt_ip = '192.168.80.111'
  $mgmt_ip = $facts['networking']['interfaces'][$mgmt_interface]['ip']
  $tnl_ip = $facts['networking']['interfaces'][$tnl_interface]['ip']
}
