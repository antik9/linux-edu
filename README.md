## Host client
```
dig @ns01.dns.lab web1.dns.lab +noall +answer       # 192.168.50.15
dig @ns01.dns.lab web2.dns.lab +noall +answer       # No match
dig @ns02.dns.lab web1.dns.lab +noall +answer       # 192.168.50.15
dig @ns02.dns.lab web2.dns.lab +noall +answer       # No match

nslookup ns01.ddns.lab                              # 192.168.50.10
nslookup ns02.ddns.lab                              # 192.168.50.11

dig @ns01.newdns.lab www.newdns.lab +noall +answer  # 192.168.50.15 192.168.50.16
dig @ns02.newdns.lab www.newdns.lab +noall +answer  # 192.168.50.15 192.168.50.16
```

## Host client2
```
dig @ns01.dns.lab web1.dns.lab +noall +answer       # 192.168.50.15
dig @ns01.dns.lab web2.dns.lab +noall +answer       # 192.168.50.16
dig @ns02.dns.lab web1.dns.lab +noall +answer       # 192.168.50.15
dig @ns02.dns.lab web2.dns.lab +noall +answer       # 192.168.50.16

nslookup ns01.ddns.lab                              # Not found
nslookup ns02.ddns.lab                              # Not found

dig @ns01.newdns.lab www.newdns.lab +noall +answer  # 192.168.50.15 192.168.50.16
dig @ns02.newdns.lab www.newdns.lab +noall +answer  # 192.168.50.15 192.168.50.16
```
