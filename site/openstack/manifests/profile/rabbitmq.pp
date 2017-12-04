class openstack::profile::rabbitmq {
  include openstack::profile::common::interfaces
  $mgmt_ip  = $openstack::profile::common::interfaces::mgmt_ip

  packagecloud::repo { 'rabbitmq/rabbitmq-server':
    type => 'deb',
  }

  apt::source { 'erlang':
    location => 'https://packages.erlang-solutions.com/ubuntu',
    release  => 'xenial',
    repos    => 'contrib',
    key      => {
      id     => '',
      server => 'hkps.pool.sks-keyservers.net',
    },
  }

  apt::pin { 'rabbitmq-server':
    packages => 'rabbitmq-server',
    priority => 1000,
    version  => '3.6.14-1',
    require  => Packagecloud::Repo['rabbitmq/rabbitmq-server'],
  }

  class { '::rabbitmq':
    service_manage    => false,
    node_ip_address   => $mgmt_ip,
    port              => '5672',
    delete_guest_user => true,
    require           => Apt::Pin['rabbitmq-server'],
    require           => Apt::Source['erlang'],
  }
}
