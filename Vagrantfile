# -*- mode: ruby -*-
# vim: set ft=ruby :
HOME = ENV['OTUS_VAGRANT_HOME']
EXTRA_VARS = {
    MASTER_IP: "10.10.0.1",
    SLAVE_IP: "10.10.0.2",
    REPL_PASS: "L4&Q%Gm)gN5xtn25",
    MASTER_PASS: "@h(fp9QbIUAnQ!zP",
    SLAVE_PASS: "oMK^jU^wRk7wu7y",
}

MACHINES = {
    "master": {
        :box_name => "centos/7",
        :net => [
            {
                virtualbox__intnet: "router-net",
                adapter: 2,
                ip: EXTRA_VARS[:MASTER_IP],
                netmask: "255.255.255.248",
            },
        ]
    },
    "slave": {
        :box_name => "centos/7",
        :net => [
            {
                virtualbox__intnet: "router-net",
                adapter: 2,
                ip: EXTRA_VARS[:SLAVE_IP],
                netmask: "255.255.255.248",
            },
        ]
    },
}


Vagrant.configure("2") do |config|

    MACHINES.each do |boxname, boxconfig|

        config.vm.define boxname do |box|

            box.vm.box = boxconfig[:box_name]
            box.vm.box_version = boxconfig[:box_version]

            box.vm.host_name = boxname.to_s

            boxconfig[:net].each do |ipconf|
                box.vm.network "private_network", ipconf
            end

            box.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", "256"]
            end

            if boxname.to_s == "slave"
                box.vm.provision "file",
                    source: ".vagrant/machines/master/virtualbox/private_key",
                    destination: "/tmp/id_rsa"
            end

            box.vm.provision "shell", inline: <<-SHELL
                mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
                [ -e /tmp/id_rsa ] && mv /tmp/id_rsa ~root/.ssh
                echo "alias vim=vi" >> /etc/bashrc
            SHELL

            box.vm.provision "ansible" do |ansible|
                _EXTRA_VARS = EXTRA_VARS.clone
                _EXTRA_VARS["HOST"] = boxname.to_s
                ansible.playbook = "provisioning/playbook.yml"
                ansible.extra_vars = _EXTRA_VARS
                ansible.verbose = 'vv'
            end
        end
    end
end
