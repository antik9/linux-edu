## Поднять OSPF между машинами на базе Quagga

### Router1

```
>>> ip a

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c0:42:d5 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85499sec preferred_lft 85499sec
    inet6 fe80::5054:ff:fec0:42d5/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:ac:9d:e8 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:5a:bd:1a brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:0e:a1:eb brd ff:ff:ff:ff:ff:ff
    inet 192.100.10.1/24 brd 192.100.10.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe0e:a1eb/64 scope link
       valid_lft forever preferred_lft forever
6: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:ac:9d:e8 brd ff:ff:ff:ff:ff:ff
    inet 10.10.1.1/24 brd 10.10.1.255 scope global vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feac:9de8/64 scope link
       valid_lft forever preferred_lft forever
7: vlan13@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:5a:bd:1a brd ff:ff:ff:ff:ff:ff
    inet 10.10.3.2/24 brd 10.10.3.255 scope global vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe5a:bd1a/64 scope link
       valid_lft forever preferred_lft forever

>>> tracepath 192.168.20.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.20.1                                          1.023ms reached
 1:  192.100.20.1                                          0.768ms reached
     Resume: pmtu 1500 hops 1 back 1

>>> tracepath 192.168.30.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.30.1                                          0.794ms reached
 1:  192.100.30.1                                          0.796ms reached
     Resume: pmtu 1500 hops 1 back 1

```

### Router2

```
>>> ip a

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c0:42:d5 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85485sec preferred_lft 85485sec
    inet6 fe80::5054:ff:fec0:42d5/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:ff:9c:ea brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:62:0c:f9 brd ff:ff:ff:ff:ff:ff
    inet 10.1.4.5/30 brd 10.1.4.7 scope global eth2
       valid_lft forever preferred_lft forever
    inet6 fe80::94c4:7eaf:2bae:7738/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:65:5f:a1 brd ff:ff:ff:ff:ff:ff
    inet 192.100.20.1/24 brd 192.100.20.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe65:5fa1/64 scope link
       valid_lft forever preferred_lft forever
6: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:ff:9c:ea brd ff:ff:ff:ff:ff:ff
    inet 10.10.1.2/24 brd 10.10.1.255 scope global vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feff:9cea/64 scope link
       valid_lft forever preferred_lft forever
7: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:62:0c:f9 brd ff:ff:ff:ff:ff:ff
    inet 10.10.2.1/24 brd 10.10.2.255 scope global vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe62:cf9/64 scope link
       valid_lft forever preferred_lft forever

>>> tracepath 192.168.10.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.10.1                                          0.398ms reached
 1:  192.100.10.1                                          0.823ms reached
     Resume: pmtu 1500 hops 1 back 1

>>> tracepath 192.168.30.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.30.1                                          0.814ms reached
 1:  192.100.30.1                                          0.757ms reached
     Resume: pmtu 1500 hops 1 back 1

```

### Router3

```
>>> ip a

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c0:42:d5 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85525sec preferred_lft 85525sec
    inet6 fe80::5054:ff:fec0:42d5/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:4b:e4:36 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:94:a6:0d brd ff:ff:ff:ff:ff:ff
    inet 10.1.4.6/30 brd 10.1.4.7 scope global eth2
       valid_lft forever preferred_lft forever
    inet6 fe80::959:bd11:3d50:a4f5/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:99:84:b5 brd ff:ff:ff:ff:ff:ff
    inet 192.100.30.1/24 brd 192.100.30.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe99:84b5/64 scope link
       valid_lft forever preferred_lft forever
6: vlan13@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:4b:e4:36 brd ff:ff:ff:ff:ff:ff
    inet 10.10.3.1/24 brd 10.10.3.255 scope global vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe4b:e436/64 scope link
       valid_lft forever preferred_lft forever
7: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:94:a6:0d brd ff:ff:ff:ff:ff:ff
    inet 10.10.2.2/24 brd 10.10.2.255 scope global vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe94:a60d/64 scope link
       valid_lft forever preferred_lft forever

>>> tracepath 192.168.10.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.10.1                                          0.752ms reached
 1:  192.100.10.1                                          0.716ms reached
     Resume: pmtu 1500 hops 1 back 1

>>> tracepath 192.168.20.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.20.1                                          0.796ms reached
 1:  192.100.20.1                                          0.821ms reached
     Resume: pmtu 1500 hops 1 back 1

```

## 2. Изобразить ассиметричный роутинг

### Router1

```

>>> tracepath 192.168.20.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.20.1                                          0.740ms reached
 1:  192.100.20.1                                          0.803ms reached
     Resume: pmtu 1500 hops 1 back 1

>>> tracepath 192.168.30.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.30.1                                          0.824ms reached
 1:  192.100.30.1                                          0.910ms reached
     Resume: pmtu 1500 hops 1 back 1

```

### Router2

```

>>> tracepath 192.168.10.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.10.1                                          0.776ms reached
 1:  192.100.10.1                                          0.360ms reached
     Resume: pmtu 1500 hops 1 back 1

>>> tracepath 192.168.30.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.30.1                                          0.962ms reached
 1:  192.100.30.1                                          0.809ms reached
     Resume: pmtu 1500 hops 1 back 1

```


### Router3

```

>>> cat ospfd.conf

!
! Zebra configuration saved from vty
!   2019/01/20 15:11:39
!
hostname ospfd
password zebra
log stdout
!
!
!
interface eth0
!
interface eth1
!
interface eth2
!
interface lo
!
interface vlan13
 ip ospf cost 100
!
interface vlan23
!
router ospf
 ospf router-id 10.10.3.1
 redistribute connected
 network 10.10.1.0/24 area 0.0.0.0
 network 10.10.2.0/24 area 0.0.0.0
 network 10.10.3.0/24 area 0.0.0.0
!
line vty
!

>>> tracepath 192.168.10.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.10.2.1                                             0.706ms
 1:  10.10.2.1                                             0.803ms
 2:  192.100.10.1                                          1.670ms reached
     Resume: pmtu 1500 hops 2 back 2

>>> tracepath 192.168.20.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.20.1                                          0.816ms reached
 1:  192.100.20.1                                          0.769ms reached
     Resume: pmtu 1500 hops 1 back 1

```

## 3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным

### Router1

```

>>> cat ospfd.conf


!
! Zebra configuration saved from vty
!   2019/01/20 15:11:39
!
hostname ospfd
password zebra
log stdout
!
!
!
interface eth0
!
interface eth1
!
interface eth2
!
interface lo
!
interface vlan12
!
interface vlan13
 ip ospf cost 200
!
router ospf
 ospf router-id 10.10.1.1
 redistribute connected
 network 10.10.1.0/24 area 0.0.0.0
 network 10.10.2.0/24 area 0.0.0.0
 network 10.10.3.0/24 area 0.0.0.0
!
line vty
!

>>> tracepath 192.168.20.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.20.1                                          0.768ms reached
 1:  192.100.20.1                                          0.737ms reached
     Resume: pmtu 1500 hops 1 back 1

>>> tracepath 192.168.30.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.10.1.2                                             0.829ms
 1:  10.10.1.2                                             0.913ms
 2:  192.100.30.1                                          1.578ms reached
     Resume: pmtu 1500 hops 2 back 2

```

### Router2

```

>>> tracepath 192.168.20.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.10.1                                          1.080ms reached
 1:  192.100.10.1                                          0.699ms reached
     Resume: pmtu 1500 hops 1 back 1

>>> tracepath 192.168.20.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.30.1                                          0.817ms reached
 1:  192.100.30.1                                          0.739ms reached
     Resume: pmtu 1500 hops 1 back 1

```

### Router3

```

>>> tracepath 192.168.20.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.10.2.1                                             0.814ms
 1:  10.10.2.1                                             0.834ms
 2:  192.100.10.1                                          1.348ms reached
     Resume: pmtu 1500 hops 2 back 2

>>> tracepath 192.168.20.1

 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.100.20.1                                          0.398ms reached
 1:  192.100.20.1                                          0.372ms reached
     Resume: pmtu 1500 hops 1 back 1

```
