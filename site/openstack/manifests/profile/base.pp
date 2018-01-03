class openstack::profile::base {

  include openstack::config

  class { 'apt':
    update => {
    frequency => 'always',
    },
  }

  class { '::openstack_extras::repo::debian::ubuntu':
    release         => 'pike',
    repo            => 'proposed',
    package_require => true,
  }
}
