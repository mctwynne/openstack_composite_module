# node default {
#   lookup('classes', {merge => unique}).include
# }

node /control/ {
  include openstack::role::controller
}

node /compute/ {
  include openstack::role::compute
}
