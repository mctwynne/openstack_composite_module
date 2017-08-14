wget http://apt.puppetlabs.com/pool/xenial/PC1/p/puppetlabs-release-pc1/puppetlabs-release-pc1_1.1.0-4xenial_all.deb
dpkg -i puppetlabs-release-pc1_1.1.0-4xenial_all.deb
apt-get update
apt-get install puppet-agent
