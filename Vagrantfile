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
                ip: '192.168.10.1',
                adapter: 3,
                netmask: "255.255.255.248",
                virtualbox__intnet: "central-net"
            },
            {
                ip: '192.168.0.1',
                adapter: 4,
                netmask: "255.255.255.240",
                virtualbox__intnet: "dir-net"
            },
            {
                ip: '192.168.0.33',
                adapter: 5,
                netmask: "255.255.255.240",
                virtualbox__intnet: "hw-net"
            },
            {
                ip: '192.168.0.65',
                adapter: 6,
                netmask: "255.255.255.192",
                virtualbox__intnet: "wifi"
            },
        ]
    },
    :centralServer => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '192.168.0.2',
                adapter: 2,
                netmask: "255.255.255.240",
                virtualbox__intnet: "dir-net"
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
                virtualbox__intnet: "test2-net"
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
    :office2Router => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '192.168.10.3',
                adapter: 2,
                netmask: "255.255.255.248",
                virtualbox__intnet: "central-net"
            },
            {
                ip: '192.168.1.1',
                adapter: 3,
                netmask: "255.255.255.128",
                virtualbox__intnet: "dev2-net"
            },
            {
                ip: '192.168.1.129',
                adapter: 4,
                netmask: "255.255.255.192",
                virtualbox__intnet: "test2-net"
            },
            {
                ip: '192.168.1.193',
                adapter: 6,
                netmask: "255.255.255.192",
                virtualbox__intnet: "hw2-net"
            },
        ]
    },
    :office1Server => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '192.168.2.2',
                adapter: 2,
                netmask: "255.255.255.192",
                virtualbox__intnet: "dev1-net"
            },
        ]
    },
    :office2Server => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '192.168.1.2',
                adapter: 2,
                netmask: "255.255.255.128",
                virtualbox__intnet: "dev2-net"
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
                    ip route add 192.168.0.0/16 via 192.168.255.2
                SHELL
            when "centralRouter"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
                    echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
                    systemctl restart network
                    echo net.ipv4.conf.all.forwarding=1 >> /etc/sysctl.conf
                    echo net.ipv4.ip_forward=1 >> /etc/systctl.conf
                    sysctl -p
                    ip route add 192.168.2.0/24 via 192.168.10.2
                    ip route add 192.168.1.0/24 via 192.168.10.3
                SHELL
            when "centralServer"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
                    echo "GATEWAY=192.168.0.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
                    systemctl restart network
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
            when "office1Server"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
                    echo "GATEWAY=192.168.10.2" >> /etc/sysconfig/network-scripts/ifcfg-eth1
                    systemctl restart network
                SHELL
            when "office2Router"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
                    echo "GATEWAY=192.168.0.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
                    systemctl restart network
                    echo net.ipv4.conf.all.forwarding=1 >> /etc/sysctl.conf
                    echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
                    sysctl -p
                SHELL
            when "office1Server"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
                    echo "GATEWAY=192.168.10.3" >> /etc/sysconfig/network-scripts/ifcfg-eth1
                    systemctl restart network
                SHELL
            end
        end
    end
end
