# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
    :inetRouter => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '192.168.255.1',
                adapter: 2,
                netmask: "255.255.255.252",
                virtualbox__intnet: "router-net"
            },
            {
                adapter: 3,
                auto_config: false,
                virtualbox__intnet: "router-net"
            },
        ]
    },
    :centralRouter => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '192.168.255.2',
                adapter: 2,
                netmask: "255.255.255.252",
                virtualbox__intnet: "router-net"
            },
            {
                adapter: 3,
                auto_config: false,
                virtualbox__intnet: "router-net"
            },
            {
                ip: '192.168.10.1',
                adapter: 4,
                netmask: "255.255.255.248",
                virtualbox__intnet: "central-net"
            },
            {
                ip: '192.168.0.1',
                adapter: 5,
                netmask: "255.255.255.240",
                virtualbox__intnet: "dir-net"
            },
            {
                ip: '192.168.0.33',
                adapter: 6,
                netmask: "255.255.255.240",
                virtualbox__intnet: "hw-net"
            },
            {
                ip: '192.168.0.65',
                adapter: 7,
                netmask: "255.255.255.192",
                virtualbox__intnet: "wifi"
            },
        ]
    },
    :office1Router => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '192.168.10.2',
                adapter: 2,
                netmask: "255.255.255.248",
                virtualbox__intnet: "central-net"
            },
            {
                ip: '192.168.2.1',
                adapter: 3,
                netmask: "255.255.255.192",
                virtualbox__intnet: "dev1-net"
            },
            {
                ip: '192.168.2.65',
                adapter: 4,
                netmask: "255.255.255.192",
                virtualbox__intnet: "test1-net"
            },
            {
                ip: '192.168.2.129',
                adapter: 5,
                netmask: "255.255.255.192",
                virtualbox__intnet: "mgt-net"
            },
            {
                ip: '192.168.2.193',
                adapter: 6,
                netmask: "255.255.255.192",
                virtualbox__intnet: "hw1-net"
            },
        ]
    },
    :testClient1 => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '192.168.2.66',
                adapter: 2,
                netmask: "255.255.255.192",
                virtualbox__intnet: "test1-net"
            },
        ]
    },
    :testServer1 => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '192.168.2.67',
                adapter: 2,
                netmask: "255.255.255.192",
                virtualbox__intnet: "test1-net"
            },
        ]
    },
    :testClient2 => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '192.168.2.68',
                adapter: 2,
                netmask: "255.255.255.192",
                virtualbox__intnet: "test1-net"
            },
        ]
    },
    :testServer2 => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '192.168.2.69',
                adapter: 2,
                netmask: "255.255.255.192",
                virtualbox__intnet: "test1-net"
            },
        ]
    },
}

Vagrant.configure("2") do |config|

    MACHINES.each do |boxname, boxconfig|

        config.vm.define boxname do |box|

            box.vm.box = boxconfig[:box_name]
            box.vm.host_name = boxname.to_s

            boxconfig[:net].each do |ipconf|
                box.vm.network "private_network", ipconf
            end

            if boxconfig.key?(:public)
                box.vm.network "public_network", boxconfig[:public]
            end

            box.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", "256"]
            end

            box.vm.provision "shell", inline: <<-SHELL
                mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
            SHELL

            case boxname.to_s
            when "inetRouter"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo net.ipv4.conf.all.forwarding=1 >> /etc/sysctl.conf
                    sysctl -p
                    iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o eth0 -j MASQUERADE
                    echo '192.168.0.0/16 via 192.168.255.2' \
                        > /etc/sysconfig/network-scripts/route-bond0
                    cat > /etc/sysconfig/network-scripts/ifcfg-bond0 << EOF
DEVICE=bond0
ONBOOT=yes
TYPE=Bond
BONDING_MASTER=yes
IPADDR=192.168.255.1
PREFIX=30
BOOTPROTO=static
USERCTL=no
BONDING_OPTS="mode=1 miimon=100 fail_over_mac=1"
EOF
                    cat > /etc/sysconfig/network-scripts/ifcfg-eth1 << EOF
DEVICE=eth1
ONBOOT=yes
SLAVE=yes
MASTER=bond0
BOOTPROTO=none
EOF
                    cat > /etc/sysconfig/network-scripts/ifcfg-eth2 << EOF
DEVICE=eth2
ONBOOT=yes
SLAVE=yes
MASTER=bond0
BOOTPROTO=none
EOF
                    systemctl restart network
                SHELL
            when "centralRouter"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
                    cat > /etc/sysconfig/network-scripts/ifcfg-bond0 << EOF
DEVICE=bond0
ONBOOT=yes
TYPE=Bond
BONDING_MASTER=yes
IPADDR=192.168.255.2
PREFIX=30
BOOTPROTO=static
USERCTL=no
GATEWAY=192.168.255.1
BONDING_OPTS="mode=1 miimon=100 fail_over_mac=1"
EOF
                    cat > /etc/sysconfig/network-scripts/ifcfg-eth1 << EOF
DEVICE=eth1
ONBOOT=yes
SLAVE=yes
MASTER=bond0
BOOTPROTO=none
EOF
                    cat > /etc/sysconfig/network-scripts/ifcfg-eth2 << EOF
DEVICE=eth2
ONBOOT=yes
SLAVE=yes
MASTER=bond0
BOOTPROTO=none
EOF
                    echo '192.168.2.0/24 via 192.168.10.2' \
                        > /etc/sysconfig/network-scripts/route-eth3
                    systemctl restart network
                    echo net.ipv4.conf.all.forwarding=1 >> /etc/sysctl.conf
                    echo net.ipv4.ip_forward=1 >> /etc/systctl.conf
                    sysctl -p
                SHELL
            when "office1Router"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
                    echo "GATEWAY=192.168.0.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
                    systemctl restart network
                    echo net.ipv4.conf.all.forwarding=1 >> /etc/sysctl.conf
                    echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
                    sysctl -p
                SHELL
            when "testClient1"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
                    echo "GATEWAY=192.168.2.65" >> /etc/sysconfig/network-scripts/ifcfg-eth1
                    cat > /etc/sysconfig/network-scripts/ifcfg-eth1.100 << EOF
VLAN=yes
DEVICE=eth1.100
BOOTPROTO=static
ONBOOT=yes
TYPE=Ethernet
IPADDR=10.10.10.254
PREFIX=24
NM_CONTROLLED=no
EOF
                    systemctl restart network
                SHELL
            when "testServer1"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
                    echo "GATEWAY=192.168.2.65" >> /etc/sysconfig/network-scripts/ifcfg-eth1
                    cat > /etc/sysconfig/network-scripts/ifcfg-eth1.100 << EOF
VLAN=yes
DEVICE=eth1.100
BOOTPROTO=static
ONBOOT=yes
TYPE=Ethernet
IPADDR=10.10.10.1
PREFIX=24
NM_CONTROLLED=no
EOF
                    systemctl restart network
                SHELL
            when "testClient2"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
                    echo "GATEWAY=192.168.2.65" >> /etc/sysconfig/network-scripts/ifcfg-eth1
                    cat > /etc/sysconfig/network-scripts/ifcfg-eth1.200 << EOF
VLAN=yes
DEVICE=eth1.200
BOOTPROTO=static
ONBOOT=yes
TYPE=Ethernet
IPADDR=10.10.10.254
PREFIX=24
NM_CONTROLLED=no
EOF
                    systemctl restart network
                SHELL
            when "testServer2"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
                    echo "GATEWAY=192.168.2.65" >> /etc/sysconfig/network-scripts/ifcfg-eth1
                    cat > /etc/sysconfig/network-scripts/ifcfg-eth1.200 << EOF
VLAN=yes
DEVICE=eth1.200
BOOTPROTO=static
ONBOOT=yes
TYPE=Ethernet
IPADDR=10.10.10.1
PREFIX=24
NM_CONTROLLED=no
EOF
                    systemctl restart network
                SHELL
            end
        end
    end
end
