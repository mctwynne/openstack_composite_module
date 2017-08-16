class openstack::profile::common::interfaces {
  $mgmt_interface = 'ens3'
  $vxlan_interface = 'ens4'
  $mgmt_ip = $facts['networking']['interfaces'][$mgmt_interface]['ip']
}
