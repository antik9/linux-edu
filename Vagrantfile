# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
    :server => {
        :box_name => "centos/7",
        :net => [
            {
                adapter: 2,
                ip: "10.1.1.1",
                netmask: "255.255.255.252",
                virtualbox__intnet: "vpn-net",
            },
            {
                adapter: 3,
                ip: "10.3.1.1",
                netmask: "255.255.255.252",
                virtualbox__intnet: "internal-net",
            },
        ]
    },
    :client => {
        :box_name => "centos/7",
        :net => [
            {
                adapter: 2,
                ip: "10.1.1.2",
                netmask: "255.255.255.252",
                virtualbox__intnet: "vpn-net",
            },
        ]
    },
    :local => {
        :box_name => "centos/7",
        :net => [
            {
                adapter: 2,
                ip: "10.3.1.2",
                netmask: "255.255.255.252",
                virtualbox__intnet: "internal-net",
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

            if boxname.to_s != "server"
                box.vm.provision "file",
                    source: ".vagrant/machines/server/virtualbox/private_key",
                    destination: "~vagrant/.ssh/id_rsa"
            end

            box.vm.provision "shell", inline: <<-SHELL
                mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/* ~root/.ssh
                echo alias vim=vi >> /etc/bashrc
            SHELL

            box.vm.provision "ansible" do |ansible|
                if boxname.to_s == "local"
                    ansible.extra_vars = {
                        ROLE: "local",
                        REMOTE_NET: "10.1.1.0",
                        SERVER_IP: "10.3.1.1",
                    }
                end
                ansible.verbose = '-vv'
                ansible.playbook = "#{boxname.to_s}.yml"
            end
        end
    end
end
