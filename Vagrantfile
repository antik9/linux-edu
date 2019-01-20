# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
    :router1 => {
        :box_name => "centos/7",
        :net => [
            {
                adapter: 2,
                auto_config: false,
                virtualbox__intnet: "1to2-net",
            },
            {
                adapter: 3,
                auto_config: false,
                virtualbox__intnet: "1to3-net",
            },
            {
                adapter: 4,
                ip: "192.100.10.1",
                netmask: "255.255.255.0",
                virtualbox__intnet: "router1-net",
            },
        ]
    },
    :router2 => {
        :box_name => "centos/7",
        :net => [
            {
                adapter: 2,
                auto_config: false,
                virtualbox__intnet: "1to2-net",
            },
            {
                adapter: 3,
                auto_config: false,
                virtualbox__intnet: "2to3-net",
            },
            {
                adapter: 4,
                ip: "192.100.20.1",
                netmask: "255.255.255.0",
                virtualbox__intnet: "router2-net",
            },
        ]
    },
    :router3 => {
        :box_name => "centos/7",
        :net => [
            {
                adapter: 2,
                auto_config: false,
                virtualbox__intnet: "1to3-net",
            },
            {
                adapter: 3,
                auto_config: false,
                virtualbox__intnet: "2to3-net",
            },
            {
                adapter: 4,
                ip: "192.100.30.1",
                netmask: "255.255.255.0",
                virtualbox__intnet: "router3-net",
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
                echo net.ipv4.conf.all.forwarding=1 >> /etc/sysctl.conf
                echo net.ipv4.conf.all.rp_filter=0 >> /etc/sysctl.conf
                sysctl -p
                echo alias vim=vi >> /etc/bashrc
                yum install -y iputils tcpdump quagga
            SHELL

            case boxname.to_s
            when "router1"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    cp /vagrant/configs/zebra_1.conf /etc/quagga/zebra.conf
                    cp /vagrant/configs/ospfd_1.conf /etc/quagga/ospfd.conf
                    cp /vagrant/configs/router1-ifcfg-vlan12 \
                        /etc/sysconfig/network-scripts/ifcfg-vlan12
                    cp /vagrant/configs/router1-ifcfg-vlan13 \
                        /etc/sysconfig/network-scripts/ifcfg-vlan13
                SHELL
            when "router2"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    cp /vagrant/configs/zebra_2.conf /etc/quagga/zebra.conf
                    cp /vagrant/configs/ospfd_2.conf /etc/quagga/ospfd.conf
                    cp /vagrant/configs/router2-ifcfg-vlan12 \
                        /etc/sysconfig/network-scripts/ifcfg-vlan12
                    cp /vagrant/configs/router2-ifcfg-vlan23 \
                        /etc/sysconfig/network-scripts/ifcfg-vlan23
                SHELL
            when "router3"
                box.vm.provision "shell", run: "always", inline: <<-SHELL
                    cp /vagrant/configs/zebra_3.conf /etc/quagga/zebra.conf
                    cp /vagrant/configs/ospfd_3.conf /etc/quagga/ospfd.conf
                    cp /vagrant/configs/router3-ifcfg-vlan13 \
                        /etc/sysconfig/network-scripts/ifcfg-vlan13
                    cp /vagrant/configs/router3-ifcfg-vlan23 \
                        /etc/sysconfig/network-scripts/ifcfg-vlan23
                SHELL
            end

            box.vm.provision "shell", inline: <<-SHELL
                chown quagga:quaggavt /etc/quagga/ospfd.conf
                systemctl restart network
                systemctl enable zebra ospfd
                systemctl start zebra ospfd
            SHELL
        end
    end
end
