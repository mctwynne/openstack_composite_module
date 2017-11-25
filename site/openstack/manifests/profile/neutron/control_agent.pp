class openstack::profile::neutron::control_agent {

  include ::openstack::profile::neutron::common
  include openstack::profile::common::interfaces

  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip
  $tnl_ip = $openstack::profile::common::interfaces::tnl_ip
  $driver         = 'openvswitch'
  $metadata_protocol    = 'http'

  class { '::neutron::plugins::ml2::ovn':
    ovn_nb_connection => "tcp:${controller_mgmt_ip}:6641",
    ovn_sb_connection => "tcp:${controller_mgmt_ip}:6642",
  }

  # This isn't available in ::neutron::plugins::ml2::ovn
  # for some reason. Add it manually for now.
  neutron_plugin_ml2 {
    'ovn/ovn_l3_scheduler' : value => 'chance';
  }

  class { '::ovn::northd':
    dbs_listen_ip => $controller_mgmt_ip,
  }
}
