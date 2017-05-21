class openstack::profile::horizon {

  class { '::horizon':
    servername                   =>  'controller.tuxadero.com',
    secret_key                   => 'big_secret',
    allowed_hosts                => '*',
    #listen_ssl                  => $::openstack_integration::config::ssl,
    #ssl_redirect                => $::openstack_integration::config::ssl,
    #horizon_cert                => $::openstack_integration::params::cert_path,
    #horizon_key                 => "/etc/openstack-dashboard/ssl/private/${::fqdn}.pem",
    #horizon_ca                  => $::openstack_integration::params::ca_bundle_cert_path,
    keystone_url                 => 'http://127.0.0.1:5000/v3',
    # need to disable offline compression due to
    # https://bugs.launchpad.net/ubuntu/+source/horizon/+bug/1424042
    compress_offline             => false,
    keystone_multidomain_support => true,
  }
}
