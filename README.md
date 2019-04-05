## Run playbook with vagrant
```bash
>>> vagrant up
```

## Run backup
```bash
>>> vagrant ssh barman
>>> sudo su barman
>>> export PATH=$PATH:/usr/pgsql-10/bin
>>> export PGPASSWORD=jSW4t5AWKpTKPLu6      # From Vagrantfile.EXTRA_VARS
>>> barman backup slave
```
