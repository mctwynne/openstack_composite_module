#!/bin/bash

base_dir='/root/puppet'
manifest="${base_dir}/manifest/site.pp"

/opt/puppetlabs/bin/puppet apply --test --report --summarize \
	--modulepath "${base_dir}/site/:${base_dir}/modules/" \
	--environmentpath "${base_dir}/../" \
	# --hiera_config "${base_dir}/hiera.yaml" \
	--detailed-exitcodes $manifest
