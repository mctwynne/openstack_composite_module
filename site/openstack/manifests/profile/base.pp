class openstack::profile::base {

  class { 'apt':
    update => {
    frequency => 'always',
    },
  }

  class { '::openstack_extras::repo::debian::ubuntu':
    release         => 'ocata',
    package_require => true,
  }
}
