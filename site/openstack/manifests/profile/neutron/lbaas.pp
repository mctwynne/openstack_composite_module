class openstack::profile::neutron::lbaas {
	rabbitmq_user { 'octavia':
		admin    => true,
		password => 'super_secret',
		provider => 'rabbitmqctl',
		require  => Class['rabbitmq'],
	}

	rabbitmq_user_permissions { 'octavia@/':
		configure_permission => '.*',
		write_permission     => '.*',
		read_permission      => '.*',
		provider             => 'rabbitmqctl',
		require              => Class['rabbitmq'],
	}

  class { '::octavia::db::mysql':
    password      => 'super_secret',
    allowed_hosts => '*',
  }

  class { '::octavia::keystone::auth':
    password => 'super_secret',
  }

  class { '::octavia::db':
    database_connection => } 'mysql+pymysql://octavia:super_secret@127.0.0.1/octavia?charset=utf8',
  }

	class { '::octavia::logging':
		debug => true,
	}

	class { '::octavia':
		default_transport_url => 'rabbit://octavia:super_secret@127.0.0.1:5672/',
	}

	class { '::octavia::keystone::authtoken':
		password => 'super_secret',
	}

	class { '::octavia::api':
		sync_db => true,
	}

	class { '::octavia::worker':
		amp_flavor_id => '65',
	}

	class { '::octavia::health_manager':
		heartbeat_key => 'abcdefghijkl',
	}

	class { '::octavia::housekeeping':
	}

  class { '::neutron::services::lbaas::octavia':
    allocates_vip  => true,
    admin_user     => 'octavia',
    admin_password => 'super_secret',
  }
}
