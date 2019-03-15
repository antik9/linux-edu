# -*- mode: ruby -*-
# vim: set ft=ruby :
HOME = ENV['OTUS_VAGRANT_HOME']
EXTRA_VARS = {
    MASTER_IP: "10.10.0.1",
    SLAVE_IP: "10.10.0.2",
    BACKUP_SERVER_IP: "10.10.0.3",
    NETMASK: 29,
    DB_DIR: "/data/db",
    REPLICA_USER: "replica",
    REPLICA_PASS: "2GQDy8AINcYxUQVF",
    DATABASE: "testdb",
    SLOT_NAME: "replica_slot",
    BACKUP_USER: "barman",
    BACKUP_HOST: "barman",
    BACKUP_PASS: "jSW4t5AWKpTKPLu6",
    SLAVE_HOST: "slave",
}

MACHINES = {
    "master": {
        :box_name => "centos/7",
        :net => [
            {
                ip: EXTRA_VARS[:MASTER_IP],
                adapter: 2,
                netmask: "255.255.255.248",
                virtualbox__intnet: "db-net",
            },
        ]
    },
    "slave": {
        :box_name => "centos/7",
        :net => [
            {
                ip: EXTRA_VARS[:SLAVE_IP],
                adapter: 2,
                netmask: "255.255.255.248",
                virtualbox__intnet: "db-net",
            },
        ]
    },
    "barman": {
        :box_name => "centos/7",
        :net => [
            {
                ip: EXTRA_VARS[:BACKUP_SERVER_IP],
                adapter: 2,
                netmask: "255.255.255.248",
                virtualbox__intnet: "db-net",
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

            box.vm.provision "shell", inline: <<-SHELL
                mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
                [ -e /tmp/id_rsa ] && mv /tmp/id_rsa ~root/.ssh
                echo "alias vim=vi" >> /etc/bashrc
            SHELL

            box.vm.provision "ansible" do |ansible|
                ansible.verbose = '-vv'
                ansible.playbook = "#{boxname.to_s}.yml"
                ansible.extra_vars = EXTRA_VARS
            end
        end
    end
end
