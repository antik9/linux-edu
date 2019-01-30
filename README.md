## Host client
```
dig @ns01.dns.lab web1.dns.lab          # 192.168.50.15
dig @ns01.dns.lab web2.dns.lab          # No match
dig @ns02.dns.lab web1.dns.lab          # 192.168.50.15
dig @ns02.dns.lab web2.dns.lab          # No match

nsroute ns01.ddns.lab                   # 192.168.50.10
nsroute ns02.ddns.lab                   # 192.168.50.11

dig @ns01.newdns.lab www.newdns.lab     # 192.168.50.15 192.168.50.16
dig @ns02.newdns.lab www.newdns.lab     # 192.168.50.15 192.168.50.16
```

## Host client2
```
dig @ns01.dns.lab web1.dns.lab          # 192.168.50.15
dig @ns01.dns.lab web2.dns.lab          # 192.168.50.16
dig @ns02.dns.lab web1.dns.lab          # 192.168.50.15
dig @ns02.dns.lab web2.dns.lab          # 192.168.50.16

nsroute ns01.ddns.lab                   # Not found
nsroute ns02.ddns.lab                   # Not found

dig @ns01.newdns.lab www.newdns.lab     # 192.168.50.15 192.168.50.16
dig @ns02.newdns.lab www.newdns.lab     # 192.168.50.15 192.168.50.16
```
