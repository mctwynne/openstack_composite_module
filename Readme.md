# Do not use for production, passwords are hardcoded

### Requierments
ruby
r10k

### Download the openstack module via r10k
```
r10k puppetfile install
```

### log into the controller and fix the cell
#### fix me in the puppet profile
```
source openrc
nova-status upgrade check
nova-manage cell_v2 simple_cell_setup
nova-status upgrade check
```

Browse to the Controller's IP Address.

Login: admin
password: super_secret 
