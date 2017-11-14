class openstack::profile::neutron::control_agent {

  include ::openstack::profile::neutron::common
  include openstack::profile::common::interfaces

  $controller_mgmt_ip = $openstack::profile::common::interfaces::controller_mgmt_ip
  $tnl_ip = $openstack::profile::common::interfaces::tnl_ip
  $driver         = 'linuxbridge'
  $metadata_protocol    = 'http'

  class { '::neutron::agents::ml2::linuxbridge':
    local_ip                    => $tnl_ip,
    tunnel_types                => ['vxlan'],
    l2_population               => true,
    physical_interface_mappings => ['external:ens5'],
  }

  class { '::neutron::agents::metadata':
    debug                 => true,
    shared_secret         => 'a_big_secret',
    metadata_protocol     => $metadata_protocol,
    metadata_insecure     => false,
    metadata_ip           => $controller_mgmt_ip,
  }

  class { '::neutron::agents::l3':
    interface_driver => $driver,
    debug            => true,
  }

  class { '::neutron::agents::dhcp':
    interface_driver => $driver,
    debug            => true,
  }
}
