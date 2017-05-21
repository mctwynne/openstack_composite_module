class openstack::profile::neutron::agent {

  include ::openstack::profile::neutron::common

  $driver         = 'openvswitch'
  $metadata_protocol    = 'http'

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => true,
    local_ip         => '192.168.0.20',
    enabled          => true,
    tunnel_types     => ['vxlan'],
    bridge_mappings  => ['external:br-ex'],
    manage_vswitch   => true,
    firewall_driver  => 'openvswitch',
  }
  class { '::neutron::agents::metadata':
    debug             => true,
    shared_secret     => 'a_big_secret',
    metadata_workers  => 2,
    metadata_protocol => $metadata_protocol,
    metadata_insecure => false,
    #nova_client_cert  => $nova_client_cert,
    #nova_client_priv_key => $nova_client_priv_key,
  }
  class { '::neutron::agents::l3':
    interface_driver => $driver,
    debug            => true,
    extensions       => 'fwaas',
  }
  class { '::neutron::agents::dhcp':
    interface_driver => $driver,
    debug            => true,
  }
}
