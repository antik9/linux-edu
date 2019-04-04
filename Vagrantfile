# -*- mode: ruby -*-
# vim: set ft=ruby :
HOME = ENV['OTUS_VAGRANT_HOME']
EXTRA_VARS = {
    NODE_1_IP: "10.10.0.1",
    NODE_2_IP: "10.10.0.2",
    NODE_3_IP: "10.10.0.3",
    ETCD_IP: "10.10.0.4",
    ETCD_PORT: 2379,
    HAPROXY_IP: "10.10.0.5",
    NETMASK: 29,
    DB_DIR: "/data/patroni",
    REPLICA_USER: "replica",
    REPLICA_PASS: "2GQDy8AINcYxUQVF",
    ADMIN_USER: "admin",
    ADMIN_PASS: "jSW4t5AWKpTKPLu6",
    SCOPE: "cluster",
    POSTGRES_PASS: "7miIVyfD0Vj8JTaI",
    HAPROXY_PORT: 5000,
    STATS_PORT: 7000,
}

MACHINES = {
    "node1": {
        :box_name => "centos/7",
        :net => [
            {
                ip: EXTRA_VARS[:NODE_1_IP],
                adapter: 2,
                netmask: "255.255.255.248",
                virtualbox__intnet: "db-net",
            },
        ],
    },
    "node2": {
        :box_name => "centos/7",
        :net => [
            {
                ip: EXTRA_VARS[:NODE_2_IP],
                adapter: 2,
                netmask: "255.255.255.248",
                virtualbox__intnet: "db-net",
            },
        ],
    },
    "node3": {
        :box_name => "centos/7",
        :net => [
            {
                ip: EXTRA_VARS[:NODE_3_IP],
                adapter: 2,
                netmask: "255.255.255.248",
                virtualbox__intnet: "db-net",
            },
        ],
    },
    "etcd": {
        :box_name => "centos/7",
        :net => [
            {
                ip: EXTRA_VARS[:ETCD_IP],
                adapter: 2,
                netmask: "255.255.255.248",
                virtualbox__intnet: "db-net",
            },
        ],
    },
    "haproxy": {
        :box_name => "centos/7",
        :net => [
            {
                ip: EXTRA_VARS[:HAPROXY_IP],
                adapter: 2,
                netmask: "255.255.255.248",
                virtualbox__intnet: "db-net",
            },
        ],
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

            if boxname.to_s == "haproxy"
                box.vm.network "forwarded_port", guest: 5000, host: 5000, auto_correct: true
                box.vm.network "forwarded_port", guest: 7000, host: 7000, auto_correct: true
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
                extra_vars = EXTRA_VARS.clone
                extra_vars[:CURRENT_NODE_IP] = MACHINES[boxname.to_sym][:net][0][:ip]
                extra_vars[:CURRENT_NODE_HOST] = boxname.to_s
                ansible.verbose = '-vv'
                ansible.playbook = "#{boxname.to_s}.yml"
                ansible.extra_vars = extra_vars
            end
        end
    end
end
