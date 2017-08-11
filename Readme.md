# Do not use for production, passwords are hardcoded

### Requierments
vagrant
virtualbox
r10k

### Download the openstack module via r10k
```
r10k puppetfile install
```

### start the controller 
```
vagrant up controller
```

### log into the controller and fix the cell
#### fix me in the puppet profile
```
vagrant ssh controller
sudo -i
nova-status upgrade check
nova-manage cell_v2 simple_cell_setup
nova-status upgrade check
```

### start the compute node
```
vagrant up compute
```

### add an entry to your /etc/hosts
```
192.168.0.10	controller.tuxadero.com
```
open controller.tuxadero.com in your browser

Login: admin
password: super_secret 
