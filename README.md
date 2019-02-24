## Run playbook and look at two shared directories from server with nfs3 and server with nfs4 and kerberos authentication
```bash
>>> vagrant up
>>> vagrant ssh client
>>> ls /nfs_share/common/
public
>>> kinit vagrant
>>> ls /kerberos_share/common/
public
```
