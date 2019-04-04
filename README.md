## Run playbook with vagrant
```bash
>>> vagrant up
```

## Run failover
```bash
>>> vagrant ssh node1
>>> patronictl -d etcd://10.10.0.4:2379 failover cluster
```

## Run switchover
```bash
>>> vagrant ssh node1
>>> patronictl -d etcd://10.10.0.4:2379 switchover cluster
```

## Change config
Add line max_connections = 100 to /etc/patroni.yml postgresql.parameters
```bash
>>> vagrant ssh node1
>>> patronictl -d etcd://10.10.0.4:2379 restart cluster
```

## See connections from outside to DB
Open http://localhost:7000 in browser
Make some requests
```bash
>>> psql -Upostgres -hlocalhost -p5000 --password
```
The stats will be uniformly distributed between replicas.
