class openstack::profile::rabbitmq {
  #  apt::key { 'erlang':
  #    id         => 'D208507CA14F4FCA',
  #    key_source => 'https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc',
  #  }
  #
  #  apt::source { 'erlang':
  #    location => 'https://packages.erlang-solutions.com/ubuntu',
  #    repos    => 'contrib',
  #  }

  include packagecloud

  packagecloud::repo { 'rabbitmq/rabbitmq-server':
    type => 'deb',
  }

  class { '::rabbitmq':
    service_manage    => false,
    port              => '5672',
    delete_guest_user => true,
  }

}
