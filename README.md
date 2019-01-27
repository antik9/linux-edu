## TAN and TUP interfaces

```
>>> iperf -s    # tap interface

------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 10.2.0.1 port 5001 connected with 10.2.0.2 port 52236
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-30.0 sec  2.44 GBytes   699 Mbits/sec


>>> iperf -s    # tun interface

------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 10.2.0.1 port 5001 connected with 10.2.0.6 port 44326
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-30.0 sec  2.71 GBytes   776 Mbits/sec
```

## Remote Access Server

```
>>> vagrant up
>>> vagrant ssh local   # Local server
>>> ping 10.1.1.2       # Client server
```
