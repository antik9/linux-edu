# -*- mode: ruby -*-
# vim: set ft=ruby :
EXTRA_VARS = {
    FIRST_PORT: 8632,
    SECOND_PORT: 6513,
    THIRD_PORT: 8479,
    INET_ROUTER_HOST: "192.168.255.1",
}

MACHINES = {
    :inetRouter => {
        :box_name => "centos/7",
        :net => [
            {
                ip: EXTRA_VARS[:INET_ROUTER_HOST],
                adapter: 2,
                netmask: "255.255.255.252",
                virtualbox__intnet: "router-net"
            },
        ]
    },
    :inetRouter2 => {
        :box_name => "centos/7",
        :net => [
            {
                ip: '10.10.0.1',
                adapter: 2,
                netmask: "255.255.255.252",
                virtualbox__intnet: "nginx-net"
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
                ip: '192.168.0.1',
                adapter: 3,
                netmask: "255.255.255.240",
                virtualbox__intnet: "dir-net"
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
            {
                ip: '10.10.0.2',
                adapter: 3,
                netmask: "255.255.255.252",
                virtualbox__intnet: "nginx-net"
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
                echo 'alias vim=vi' >> /etc/bashrc
            SHELL

            if boxname.to_s == "inetRouter2"
                box.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
            end

            if boxname.to_s == "centralServer"
                box.vm.provision "ansible" do |ansible|
                    ansible.verbose = '-vv'
                    ansible.playbook = "#{boxname.to_s}.yml"
                end
            else
                box.vm.provision "ansible" do |ansible|
                    ansible.verbose = '-vv'
                    ansible.playbook = "configs/playbook.yml"
                    ansible.extra_vars = EXTRA_VARS
                end
            end
        end
    end
end
