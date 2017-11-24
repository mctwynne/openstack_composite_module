class openstack::profile::neutron::control_agent {

  include ::openstack::profile::neutron::common
  include openstack::profile::common::interfaces

  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip
  $driver         = 'openvswitch'
  $metadata_protocol    = 'http'

  # class { '::neutron::agents::ml2::ovs':
  #   enable_tunneling => true,
  #   local_ip         => $controller_mgmt_ip,
  #   enabled          => true,
  #   tunnel_types     => ['vxlan'],
  #   bridge_uplinks   => ['br-ex:ens5'],
  #   bridge_mappings  => ['external:br-ex'],
  #   manage_vswitch   => true,
  #   firewall_driver  => 'iptables_hybrid',
  #   l2_population    => true,
  # }

  # class { '::neutron::agents::metadata':
  #   debug                 => true,
  #   shared_secret         => 'a_big_secret',
  #   metadata_workers      => 2,
  #   metadata_protocol     => $metadata_protocol,
  #   metadata_insecure     => false,
  #   metadata_ip           => $controller_mgmt_ip,
  # }

  # class { '::neutron::agents::l3':
  #   interface_driver => $driver,
  #   debug            => true,
  #   agent_mode       => 'dvr_snat',
  # }

  # class { '::neutron::agents::dhcp':
  #   interface_driver => $driver,
  #   debug            => true,
  # }

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
