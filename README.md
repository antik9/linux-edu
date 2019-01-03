## InetRouter

> **inet 192.168.255.1  netmask 255.255.255.252  broadcast 192.168.255.3**
```
-> Free subnet: 192.168.255.4-255
-> Busy: all
-> Free nodes: 0
```

## CentralRouter
> **inet 192.168.10.1  netmask 255.255.255.248  broadcast 192.168.10.7**
```
-> Free subnet: 192.168.10.8-255
-> Busy: 1-3
-> Free nodes: 4-6
```
> **inet 192.168.0.1  netmask 255.255.255.240  broadcast 192.168.0.15**
```
-> Free subnet: 192.168.10.16-31
```
> **inet 192.168.0.33  netmask 255.255.255.240  broadcast 192.168.0.47**
```
-> Free subnet: 192.168.10.48-63
```
> **inet 192.168.0.65  netmask 255.255.255.192  broadcast 192.168.0.127**
```
-> Free subnet: 192.168.10.128-255
```

## Office1Router

> *inet 192.168.2.1  netmask 255.255.255.192  broadcast 192.168.2.63*<br />
> *inet 192.168.2.65  netmask 255.255.255.192  broadcast 192.168.2.127*<br />
> *inet 192.168.2.129  netmask 255.255.255.192  broadcast 192.168.2.191*<br />
> *inet 192.168.2.193  netmask 255.255.255.192  broadcast 192.168.2.255*<br />

## Office2Router
> *inet 192.168.1.1  netmask 255.255.255.128  broadcast 192.168.1.127*<br />
> *inet 192.168.1.129  netmask 255.255.255.192  broadcast 192.168.1.191*<br />
> *inet 192.168.1.193  netmask 255.255.255.192  broadcast 192.168.1.255*<br />
